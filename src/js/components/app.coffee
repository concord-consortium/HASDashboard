React = require 'react'
$ = require 'jquery'
_ = require 'lodash'

require '../../css/activity_background.styl'

ActivityBackround = React.createFactory require './activity_background.coffee'
NavOverlay        = React.createFactory require './nav_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'

offeringFakeData  = require '../data/fake_offering.coffee'
sequenceFakeData  = require '../data/fake_sequence.coffee'
runsFakeData      = require '../data/fake_runs.coffee'
dataHelpers       = require '../data/helpers.coffee'
utils             = require '../utils.coffee'

ShowingOverview        = "ShowingOverview"
ShowingStudentDetails  = "ShowingStudentDetails"
ShowingQuestionDetails = "ShowingQuestionDetails"

ACTIVITY_ID_REGEXP = /activities\/(\d+)/
SEQUENCE_ID_REGEXP = /sequences\/(\d+)/
REPORT_UPDATE_INTERVAL = 15000 # ms

{div} = React.DOM

App = React.createClass
  getInitialState: ->
    laraBaseUrl: null
    activityId: null
    sequenceId: null
    pageId: null
    studentsPortalInfo: []
    students: []
    sequence: null
    showReport: false
    showNav: true
    nowShowing: ShowingOverview
    selectedStudent: null
    selectedQuestion: null
    # LARA returns runs data per page, so we need to save timestamps for every single page (hash).
    pageDataTimestamps: {}

  componentDidMount: ->
    # Look for ?offering= parameter and use it to get the offering information.
    # If param is not provided, we will load fake offering data (from `data/offering.coffee`).
    # Note that you can replace data/offering.coffee content to point to real LARA instance.
    params = utils.urlParams()
    @setOffering(params.offering)

    # Refresh report.

    setInterval =>
      # Don't call LARA API if page is inactive. document.hidden is part of the Page Visibility API:
      # https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API
      # If it's not supported, document.hidden will be undefined, but that's fine for our needs.
      return if document.hidden
      # Dont need to reload data if we are just generating it randomly
      return if @useFakeData()
      # New students can be added to class or their endpoint_url can be updated once
      # they start an activity.
      @setOffering(params.offering)
      @setStudents()
    , REPORT_UPDATE_INTERVAL

  componentDidUpdate: (prevProps, prevState) ->
    if !_.isEqual(@state.studentsPortalInfo, prevState.studentsPortalInfo) || @state.pageId != prevState.pageId
      # students data depends on students' endpoint URLs and pageId, so when they change, we need to refresh it.
      @setStudents()
    if (@state.activityId != prevState.activityId) or (@state.sequenceId != prevState.sequenceId)
      @setSequence()

  setOffering: (offeringUrl) ->
    setOffering = (data) =>
      activityId = null
      sequenceId = null
      if data.activity_url.match(ACTIVITY_ID_REGEXP)
        activityId= data.activity_url.match(ACTIVITY_ID_REGEXP)[1]
      if data.activity_url.match(SEQUENCE_ID_REGEXP)
        sequenceId= data.activity_url.match(SEQUENCE_ID_REGEXP)[1]

      @setState
        studentsPortalInfo: data.students
        laraBaseUrl: utils.baseUrl(data.activity_url)
        activityId: activityId
        sequenceId: sequenceId

    if offeringUrl
      $.ajax
        url: offeringUrl
        dataType: "jsonp"
        success: setOffering
    else
      utils.fakeAjax ->
        setOffering(offeringFakeData)

  setSequence: ->
    setSequence = (sequence) =>
      firstPage = sequence.activities[0].pages[0]
      @setState
        sequence: sequence
        pageId: firstPage.id

    if @useFakeData()
      utils.fakeAjax =>
        data = sequenceFakeData(@state.activityId)
        setSequence(data)
    else
      resources = "activities"
      id = @state.activityId
      if @state.sequenceId
        resources = "sequences"
        id = @state.sequenceId
      url = "#{@state.laraBaseUrl}/#{resources}/#{id}/dashboard_toc"
      $.ajax
        url: url
        dataType: "jsonp"
        success: setSequence

  getPageDataTimestamp: (pageId) ->
    @state.pageDataTimestamps[pageId] || null
  useFakeData: ->
    @state.laraBaseUrl is offeringFakeData.FAKE_ACTIVITY_BASE_URL

  # Accepts pageId and new timestamp, returns a new hash that can be used by .setState.
  updatedPageDataTimestamps: (pageId, newTimestamp) ->
    timestampsUpdate = {}
    timestampsUpdate[pageId] = newTimestamp
    _.assign({}, @state.pageDataTimestamps, timestampsUpdate)

  setStudents: ->
    # Wait till we have both page ID and studentsPortalInfo list.
    return if @state.pageId == null || @state.studentsPortalInfo.length == 0
    pageId = @state.pageId
    handleRunsData = (data) =>
      data = dataHelpers.toLatestVersion(data)
      runs = data.runs
      timestamp = data.timestamp
      students = dataHelpers.getStudentsData(runs, @state.studentsPortalInfo, pageId)
      tocStudents = dataHelpers.getTocStudents(runs, @state.studentsPortalInfo)
      @setState
        students: students
        tocStudents: tocStudents
        pageDataTimestamps: @updatedPageDataTimestamps(pageId, timestamp)

    if @useFakeData()
      utils.fakeAjax =>
        handleRunsData(runsFakeData(@state.studentsPortalInfo, @getQuestions(), @state.sequence))
    else
      $.ajax
        url: "#{@state.laraBaseUrl}/runs/dashboard"
        data:
          page_id: pageId,
          endpoint_urls: dataHelpers.getEndpointUrls(@state.studentsPortalInfo)
          submissions_created_after: @getPageDataTimestamp(pageId)
        dataType: "jsonp"
        success: handleRunsData

  toggleReport: ->
    showReportNext = not @state.showReport
    showNavNext    = @state.showNav and (not showReportNext)
    @setState
      showReport: showReportNext
      showNav: showNavNext

  toggleNav: ->
    showNavNext    = not @state.showNav
    showReportNext = @state.showReport and (not showNavNext)
    @setState
      showReport: showReportNext
      showNav: showNavNext

  onShowStudentDetails: (evt,student)->
    @setState
      selectedStudent: student
      nowShowing: ShowingStudentDetails

  onShowQuestionDetails: (evt,question)->
    @setState
      selectedQuestion: question
      nowShowing: ShowingQuestionDetails

  onShowOverview: ->
    @setState
      nowShowing: ShowingOverview

  setPage: (pageId) ->
    @setState
      pageId: pageId
      nowShowing: ShowingOverview
      selectedQuestion: null
      selectedStudent: null

  getCurrentPage: ->
    pages = @state.sequence?.activities.map (a) -> a.pages
    pages = _.flatten pages
    _.find pages, (p) => p.id == @state.pageId

  getQuestions: ->
    return [] unless @state.sequence
    @getCurrentPage().questions || []

  render: ->
    page = @getCurrentPage()

    (div {className: "app"},
      (ActivityBackround
        pageUrl: if page then "#{@state.laraBaseUrl}/#{page.url}" else null
      )
      (ReportOverlay
        opened: @state.showReport
        toggle: @toggleReport
        onShowStudentDetails: @onShowStudentDetails
        onShowQuestionDetails: @onShowQuestionDetails
        onShowOverview: @onShowOverview

        hideOverviewReport: @state.nowShowing isnt ShowingOverview
        hideStudentDetailsReport: @state.nowShowing isnt ShowingStudentDetails
        hideQuestionDetailsReport: @state.nowShowing isnt ShowingQuestionDetails

        selectedQuestion: @state.selectedQuestion
        selectedStudent: @state.selectedStudent
        data: @state
        questions: @getQuestions()
      )
      (NavOverlay
        opened: @state.showNav
        toggle: @toggleNav
        sequence: @state.sequence
        students: @state.tocStudents
        setPage: @setPage
      )
    )


module.exports=App

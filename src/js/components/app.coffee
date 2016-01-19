React = require 'react'
$ = require 'jquery'
_ = require 'lodash'

require '../../css/activity_background.styl'

ActivityBackround = React.createFactory require './activity_background.coffee'
NavOverlay        = React.createFactory require './nav_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'

offeringFakeData  = require '../data/offering.coffee'
activityFakeData  = require '../data/activity.coffee'
runsFakeData      = require '../data/runs.coffee'

utils = require '../utils.coffee'

ShowingOverview        = "ShowingOverview"
ShowingStudentDetails  = "ShowingStudentDetails"
ShowingQuestionDetails = "ShowingQuestionDetails"

ACTIVITY_ID_REGEXP = /activities\/(\d+)/
REPORT_UPDATE_INTERVAL = 15000 # ms

{div} = React.DOM

App = React.createClass
  getInitialState: ->
    laraBaseUrl: null
    activityId: null
    pageId: null
    pageUrl: null
    students: []
    runs: []
    activity: null
    showReport: false
    showNav: false
    nowShowing: ShowingOverview
    selectedStudent: null
    selectedQuestion: null

  componentDidMount: ->
    # Look for ?offering= parameter and use it to get the offering information.
    # If param is not provided, we will load fake offering data (from `data/offering.coffee`).
    # Note that you can replace data/offering.coffee content to point to real LARA instance.
    params = utils.urlParams()
    @setOffering(params.offering)

    # Refresh report.
    setInterval =>
      # New students can be added to class or their endpoint_url can be updated once
      # they start an activity.
      @setOffering(params.offering)
      @setRuns()
    , REPORT_UPDATE_INTERVAL

  componentDidUpdate: (prevProps, prevState) ->
    if !_.isEqual(@state.students, prevState.students) || @state.pageId != prevState.pageId
      # Runs data depends on runKey and pageId, so when they change, we need to refresh it.
      @setRuns()
    if @state.activityId != prevState.activityId
      @setActivity()

  setOffering: (offeringUrl) ->
    setOffering = (data) =>
      @setState
        students: data.students
        laraBaseUrl: utils.baseUrl(data.activity_url)
        activityId: data.activity_url.match(ACTIVITY_ID_REGEXP)[1]

    if offeringUrl
      $.ajax
        url: offeringUrl
        dataType: "jsonp"
        success: setOffering
    else
      utils.fakeAjax ->
        setOffering(offeringFakeData)

  setActivity: ->
    setActivity = (activity) =>
      firstPage = activity.pages[0]
      @setState
        activity: activity
        pageId: firstPage.id
        pageUrl: "#{@state.laraBaseUrl}/#{firstPage.url}"

    if @state.laraBaseUrl != offeringFakeData.FAKE_ACTIVITY_BASE_URL
      $.ajax
        url: "#{@state.laraBaseUrl}/activities/#{@state.activityId}/dashboard_toc"
        dataType: "jsonp"
        success: setActivity
    else
      utils.fakeAjax =>
        setActivity(activityFakeData(@state.activityId))

  setRuns: ->
    # Wait till we have both page ID and run keys list.
    return if @state.pageId == null || @state.students.length == 0
    setRuns = (runs) =>
      @setState runs: processRunsData(runs, @state.students)

    if @state.laraBaseUrl != offeringFakeData.FAKE_ACTIVITY_BASE_URL
      $.ajax
        url: "#{@state.laraBaseUrl}/runs/dashboard"
        data:
          page_id: @state.pageId,
          endpoint_urls: getEndpointUrls(@state.students)
        dataType: "jsonp"
        success: setRuns
    else
      utils.fakeAjax =>
        setRuns(runsFakeData(@state.students, @getQuestions()))

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

  setPage: (pageId, pageUrl) ->
    @setState
      pageId: pageId
      pageUrl: "#{@state.laraBaseUrl}/#{pageUrl}"
      nowShowing: ShowingOverview
      selectedQuestion: null
      selectedStudent: null

  getQuestions: ->
    return [] unless @state.activity
    (_.find @state.activity.pages, (p) => p.id == @state.pageId).questions

  render: ->
    (div {className: "app"},
      (ActivityBackround
        pageUrl: @state.pageUrl
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
        activity: @state.activity
        setPage: @setPage
      )
    )

# Combine runs data provided by LARA and students data provided by Portal.
# Note that LARA doesn't return student names or user names.
processRunsData = (runs, students) ->
  runByEndpointUrl = {}
  _.each runs, (r) -> runByEndpointUrl[r.endpoint_url] = r
  _.map students, (s) ->
    runData = runByEndpointUrl[s.endpoint_url] || {}
    runData.student_name = s.name
    runData.student_username = s.username
    filterOutNonCRaterScores(runData.submissions)
    runData

filterOutNonCRaterScores = (submissions) ->
  _.each submissions, (s) ->
    _.each s.answers, (a) ->
      if a.feedback_type != 'CRater::FeedbackItem'
        delete a.score

getEndpointUrls = (students) ->
  # Some students might have endpoint URL equal to null
  # (it means they haven't started activity yet).
  _.compact(_.map students, (s) -> s.endpoint_url)

module.exports=App

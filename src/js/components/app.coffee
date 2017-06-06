React = require "react"
$ = require "jquery"
_ = require "lodash"

require "../../css/activity_background.styl"

ActivityBackround = React.createFactory require "./activity_background.coffee"
RightOverlay      = React.createFactory require "./right_overlay.coffee"
NavOverlay        = React.createFactory require "./nav_overlay.coffee"
Error             = React.createFactory require "./error_alert.coffee"

offeringFakeData  = require "../data/fake_offering.coffee"
sequenceFakeData  = require "../data/fake_sequence.coffee"
FakeRuns          = require "../data/fake_runs.coffee"
dataHelpers       = require "../data/helpers.coffee"
utils             = require "../utils.coffee"
UrlHelper         = require "../data/urls.coffee"
LogManagerHelper  = require "../log_manager_helper.coffee"
NowShowing        = require "../now_showing.coffee"

ACTIVITY_ID_REGEXP = /activities\/(\d+)/
SEQUENCE_ID_REGEXP = /sequences\/(\d+)/
REPORT_UPDATE_INTERVAL = 15000 # ms
TIMEOUT_MS = 10000

{div} = React.DOM


App = React.createClass
  getInitialState: ->
    laraBaseUrl: null
    activityId: null
    sequenceId: null
    studentsPortalInfo: []
    students: []
    sequence: null
    showReport: false
    showNav: true
    nowShowing: NowShowing.ShowingToc
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
    @urlHelper = new UrlHelper()
    @logManager = new LogManagerHelper({activity: params.offering, username: params.username, session: params.token})
    # Refresh report.
    @logManager.log
      event: "openReport"
      activity: params.offering
      parameters:
        offering: params.offering

    @reloadInterval = setInterval =>
      # Don"t call LARA API if page is inactive. document.hidden is part of the Page Visibility API:
      # https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API
      # If it"s not supported, document.hidden will be undefined, but that"s fine for our needs.
      return if document.hidden
      # Dont need to reload data if we are just generating it randomly
      return if @useFakeData()
      # New students can be added to class or their endpoint_url can be updated once
      # they start an activity.
      @setOffering(params.offering)
      @setStudents()
    , REPORT_UPDATE_INTERVAL

  stopRefreshing: ->
    clearInterval(@reloadInterval)

  componentDidUpdate: (prevProps, prevState) ->
  # students data depends on students" endpoint URLs and pageId, so when they change, we need to refresh it.
    if !_.isEqual(@state.studentsPortalInfo, prevState.studentsPortalInfo) || @props.params.pageId != prevProps.params.pageId
      @setStudents()
    if (@state.activityId != prevState.activityId) or (@state.sequenceId != prevState.sequenceId)
      @setSequence()

  apiCall: (opts) ->
    authToken = utils.urlParams().token
    defaults =
      dataType: "json"
      timeout: TIMEOUT_MS
      headers:
        "Authorization": "Bearer #{authToken}"
      error: () => @reportError(opts.url, opts.errorContext,  arguments)
    $.ajax _.assign(defaults, opts)


  setOffering: (offeringUrl) ->

    _setOffering = (data) =>
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
      @apiCall
        url: offeringUrl
        success: _setOffering
        errorContext: "loading offering"

    else
      utils.fakeAjax ->
        _setOffering(offeringFakeData)

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
      tocUrl = @urlHelper.tocUrl(@state.laraBaseUrl, resources, id)
      @apiCall
        url: tocUrl
        success: setSequence
        dataType: "jsonp"
        errorContext: "loading table of contents"

  reportError: (url, errorContext, errors) ->
    error =
      url: url
      errorContext: errorContext
      status: errors?[0]?.status
      errorString:  errors?[1]

    console?.log?(error)
    if error.status == 401 || error.status == 403
      @stopRefreshing()

    @logManager.log
      event: "error"
      parameters:
        error: error.errorString

    @setState
      error: error


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
    pageId = @pageId()
    handleAllSequenceAnswers = (runs) =>
      allSequenceAnswers = dataHelpers.mergeAllSequenceAnswers(runs, @state.studentsPortalInfo)
      @setState
        allSequenceAnswers: allSequenceAnswers

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
        if @state.sequence
          if !@state.allSequenceAnswers
            sequence = @state.sequence
            studentsPortalInfo = @state.studentsPortalInfo
            allSequenceAnswers = FakeRuns.allSequenceAnswers(studentsPortalInfo, sequence)
            handleAllSequenceAnswers(allSequenceAnswers)
          fakeRuns = FakeRuns.fakeRuns(@state.studentsPortalInfo, @getQuestions(), @state.sequence)
          handleRunsData(fakeRuns)

    else
      dashRunsUrl = @urlHelper.dashRunsUrl(@state.laraBaseUrl)
      @apiCall
        url: dashRunsUrl
        data:
          page_id: pageId,
          endpoint_urls: dataHelpers.getEndpointUrls(@state.studentsPortalInfo)
          submissions_created_after: @getPageDataTimestamp(pageId)
        dataType: "jsonp"
        success: handleRunsData

  onClickTab: (toShow, alternate=NowShowing.ShowingNothing) ->
    nextShowing = if @state.nowShowing != toShow then  toShow else alternate
    @setState
      nowShowing: nextShowing

  onClickPageReport: ->
    @onClickTab(NowShowing.ShowingPageReport)

  onClickSummary: ->
    @onClickTab(NowShowing.ShowingSummary)

  onClickNav: ->
    @onClickTab(NowShowing.ShowingToc)


  onShowStudentDetails: (evt,student)->
    @logManager.log
      event: "showStudentDetails"
      parameters:
        name: student.name
        id: student.id
    @setState
      selectedStudent: student
      nowShowing: NowShowing.ShowingStudentDetails

  onShowQuestionDetails: (evt,question)->
    @logManager.log
      event: "showQuestionDetails"
      parameters:
        questionIndex: question.index
        questionPrompt: question.prompt
    @setState
      selectedQuestion: question
      nowShowing: NowShowing.ShowingQuestionDetails

  setPage: (page) ->
    props = page.props
    @logManager.log
      event: "setPage"
      parameters:
        name: props.name
        id: props.id
        hasQuestion: props.hasQuestion
    @setState
      selectedQuestion: null
      selectedStudent: null

  pageId: ->
    parseInt(@props.params.pageId)

  getCurrentPage: ->
    pages = @state.sequence?.activities.map (a) -> a.pages
    pages = _.flatten pages
    _.find pages, (p) => p.id == @pageId()

  getQuestions: ->
    return [] unless @state.sequence
    @getCurrentPage()?.questions || []

  data: ->
    _.assign({}, @state, {pageId: @pageId()})

  render: ->
    page = @getCurrentPage()
    (div {className: "app"},
      (ActivityBackround
        pageUrl: if page then "#{@state.laraBaseUrl}/#{page.url}" else null
      )
      (RightOverlay
        nowShowing: @state.nowShowing
        onClickPageReport: @onClickPageReport
        onClickSummary: @onClickSummary
        onShowStudentDetails: @onShowStudentDetails
        onShowQuestionDetails: @onShowQuestionDetails
        selectedQuestion: @state.selectedQuestion
        selectedStudent: @state.selectedStudent
        data: @state
        questions: @getQuestions()
      )

      (NavOverlay
        opened: @state.nowShowing == NowShowing.ShowingToc
        toggle: @onClickNav
        sequence: @state.sequence
        students: @state.tocStudents
        setPage: @setPage
        pageId: @pageId()
      )
      (Error {error: @state.error}) if @state.error
    )


module.exports=App

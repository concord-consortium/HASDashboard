Router           = require 'react-router'
{ hashHistory }   = Router

ShowingSummary=         "ShowingSummary"
ShowingPageReport=      "ShowingPageReport"
ShowingStudentDetails=  "ShowingStudentDetails"
ShowingQuestionDetails= "ShowingQuestionDetails"
ShowingNothing=         "ShowingNothing"
ShowingToc=             "ShowingToc"


class NavigationManager

  constructor: (logManager, props={}) ->
    @logManager = logManager
    @log "initializing navigation with #{props}"
    { @nowShowing, @pageId, @studentUsername, @questionId } = props

  log: (msg) ->
    console.log msg

  asProps: () ->
    { @nowShowing, @pageId, @studentUsername, @questionId }

  asPath: ()->
    nowShowing = @nowShowing || ShowingToc
    path = "nowShowing/#{nowShowing}"
    if @pageId
      path = "#{path}/pages/#{@page}"
      if @student
        path = "#{path}/students/#{@student}"
      if @question
        path = "#{path}/questions/#{@question}"
    return path

  navigatToPath: (path="") ->
    @log "navigating to #{path}"
    hashHistory.push path

  adjustNowShowing: (newNowShowing) ->
    if newNowShowing == @nowShowing
      @nowShowing = ShowingNothing
    else
      @nowShowing = newNowShowing

  change: (changes={}) ->
    newOpts = _.defaults changes, @asProps()
    { @pageId, @studentUsername, @questionId } = newOpts
    @adjustNowShowing(changes.nowShowing)

  navigateTo: (changes={}) ->
    @change(changes)
    @navigate()

  navigate: () ->
    @navigatToPath @asPath()

  onClickTab: (toShow) ->
    @navigateTo({nowShowing:toShow})

  onClickPageReport: ->
    @onClickTab(ShowingPageReport)

  onClickSummary: ->
    @onClickTab(ShowingSummary)

  onClickNav: ->
    @onClickTab(ShowingToc)


  onShowStudentDetails: (username, pageId)->
    student = _.find @state.students, (s) ->
      s.username == username
    @logManager.log
      event: "showStudentDetails"
      parameters:
        name: student.name
        id: student.id
    @navigateTo({pageId:props.id, studentUsername:username, questionId:null, nowShowing:ShowingStudentDetails})

  onShowQuestionDetails: (evt,question)->
    @logManager.log
      event: "showQuestionDetails"
      parameters:
        questionIndex: question.index
        questionPrompt: question.prompt
    @navigateTo({questionId:question.index})

  setPage: (page) ->
    props = page.props
    @logManager.log
      event: "setPage"
      parameters:
        name: props.name
        id: props.id
        hasQuestion: props.hasQuestion
    @navigateTo({pageId:props.id, studentUsername:null, questionId:null})

module.exports=
  {
    NavigationManager
    ShowingSummary
    ShowingPageReport
    ShowingStudentDetails
    ShowingQuestionDetails
    ShowingNothing
    ShowingToc
  }

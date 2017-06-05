React = require 'react'
$ = require 'jquery'
_ = require 'lodash'
s                 = require '../util/strings.coffee'
SummaryOverlay    = React.createFactory require './summary_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'
NowShowing        = require '../now_showing.coffee'
{ ShowingModule, ShowingOverview, ShowingStudentDetails, ShowingQuestionDetails } = NowShowing
{ div, span} = React.DOM

require '../../css/right_overlay.styl'


ReportTabsOverlay = React.createClass
  getInitialState: ->
    open: false,
    nowShowing: "nothing"
  showNothing: ->
    this.setState(open: false, nowShowing: "nothing")

  clickTab: (toShow) ->
    if(@state.nowShowing == toShow)
      @showNothing()
    else
      this.setState(open:true, nowShowing:toShow)

  clickModule: ->
    @clickTab("show-module")

  clickReport: ->
    @clickTab("show-report")

  className: ->
    return "right-overlay #{@state.nowShowing}"

  render: ->
    nowShowing = @state.nowShowing
    moduleTabClassName = reportTabClassName = "tab"
    if nowShowing == "show-report"
      reportTabClassName = "tab open"
      reportView = (ReportOverlay @props)
    if nowShowing == "show-module"
      moduleTabClassName = "tab open"
      reportView = (SummaryOverlay @props)

    (div {className: @className()},
      (div {className: "tabs"},
        (div {className: reportTabClassName, onClick: @clickReport},
          s "~REPORT"
        )
        (div {className: moduleTabClassName, onClick: @clickModule},
          s "~MODULE_SUMMARY"
        )
      )
      (div {className: "content"}, reportView)
    )
module.exports=ReportTabsOverlay
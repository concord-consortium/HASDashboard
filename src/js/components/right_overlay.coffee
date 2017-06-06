React = require 'react'
$ = require 'jquery'
_ = require 'lodash'
s                 = require '../util/strings.coffee'
SummaryOverlay    = React.createFactory require './summary_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'
NowShowing        = require '../now_showing.coffee'

{ div, span} = React.DOM

require '../../css/right_overlay.styl'


ReportTabsOverlay = React.createClass
  displayName: "ReportTabsOverlay"

  className: ->
    classes = @props.nowShowing
    if @showPageReportTab()
      classes = NowShowing.ShowingPageReport
    return "right-overlay #{classes}"

  showPageReportTab: ->
    nowShowing = @props.nowShowing
    return(
      nowShowing == NowShowing.ShowingPageReport ||
      nowShowing == NowShowing.ShowingQuestionDetails ||
      nowShowing == NowShowing.ShowingStudentDetails
    )


  render: ->
    nowShowing = @props.nowShowing
    moduleTabClassName = reportTabClassName = "tab"
    if @showPageReportTab()
      reportTabClassName = "tab open"
      reportView = (ReportOverlay @props)
    if nowShowing == NowShowing.ShowingSummary
      moduleTabClassName = "tab open"
      reportView = (SummaryOverlay @props)

    (div {className: @className()},
      (div {className: "tabs"},
        (div {className: reportTabClassName, onClick: @props.onClickPageReport},
          s "~REPORT"
        )
        (div {className: moduleTabClassName, onClick: @props.onClickSummary},
          s "~MODULE_SUMMARY"
        )
      )
      (div {className: "content"}, reportView)
    )
module.exports=ReportTabsOverlay
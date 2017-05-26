React = require 'react'
$ = require 'jquery'
_ = require 'lodash'
s                 = require '../util/strings.coffee'
SummaryOverlay    = React.createFactory require './summary_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'
NowShowing        = require '../now_showing.coffee'
{ ShowingModule, ShowingOverview, ShowingStudentDetails, ShowingQuestionDetails } = NowShowing
{ div } = React.DOM


ReportTabsOverlay = React.createClass
  render: ->
    nowShowing = @props.nowShowing
    reportTabClassName = if nowShowing is ShowingOverview then  "tab open" else "tab"
    moduleTabClassName = if nowShowing is ShowingModule then  "tab open" else "tab"
    (div {className: "report-tabs"},
      (div {className: "tabs"},
        (div {className: reportTabClassName, onClick: @props.toggle}, s "~REPORT")
        (div {className: moduleTabClassName, onClick: @props.toggle}, s "~MODULE_SUMMARY")
      )
      (SummaryOverlay
        opened: @props.opened
        toggle: @props.toggle
        onShowStudentDetails: @onShowStudentDetails
        onShowQuestionDetails: @onShowQuestionDetails
        onShowOverview: @onShowOverview
        onShowModule: @onShowModule

        hideOverviewReport: @props.nowShowing isnt ShowingOverview
        hideStudentDetailsReport: @props.nowShowing isnt ShowingStudentDetails
        hideQuestionDetailsReport: @props.nowShowing isnt ShowingQuestionDetails

        selectedQuestion: @props.selectedQuestion
        selectedStudent: @props.selectedStudent
        data: @props.data
        questions: @props.questions
      )
      (ReportOverlay
        opened: @props.opened
        toggle: @props.toggle
        onShowStudentDetails: @onShowStudentDetails
        onShowQuestionDetails: @onShowQuestionDetails
        onShowOverview: @onShowOverview
        onShowModule: @onShowModule

        hideOverviewReport: @props.nowShowing isnt ShowingOverview
        hideStudentDetailsReport: @props.nowShowing isnt ShowingStudentDetails
        hideQuestionDetailsReport: @props.nowShowing isnt ShowingQuestionDetails

        selectedQuestion: @props.selectedQuestion
        selectedStudent: @props.selectedStudent
        data: @props.data
        questions: @props.questions
      )
    )
module.exports=ReportTabsOverlay
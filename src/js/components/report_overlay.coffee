require '../../css/report_overlay.styl'

React         = require 'react'
openable     = require './mixins/openable.coffee'
Report       = React.createFactory require './report.coffee'
ReportDetails = React.createFactory require './report_details.coffee'
ReportQuestionDetails = React.createFactory require './report_question_details.coffee'

{div} = React.DOM

ReportOverlay = React.createClass

  mixins: [openable]

  getDefaultProps: ->
    showDetails: false
    showQuestionDetails: false

  render: ->
    (div {className: "report_overlay"},
      (div {className: @className("tab"), onClick: @props.toggle}, "Report")
      (div {className: @className("content")},
        (Report
          students: @props.data.students
          questions: @props.data.questions
          hidden: @props.showDetails is true
          hidden: @props.showQuestionDetails is true
          clickStudent: @props.toggleDetails
          clickColumnHeader: @props.toggleQuestionDetails
        )
        (ReportDetails
          data: @props.data.selectedStudent
          returnClick: @props.toggleDetails
          hidden: @props.showDetails is false
        )
        (ReportQuestionDetails
          data: @props.data.selectedQuestion
          returnClick: @props.toggleQuestionDetails
          hidden: @props.showQuestionDetails is false
        )
      )
    )

module.exports=ReportOverlay

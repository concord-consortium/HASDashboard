require '../../css/report_overlay.styl'

React         = require 'react'
openable      = require './mixins/openable.coffee'
SummaryTable = React.createFactory require './summary_table.coffee'
StudentDetailsReport = React.createFactory require './student_details_report.coffee'
QuestionDetailsReport = React.createFactory require './question_details_report.coffee'

{div} = React.DOM

SummaryOverlay = React.createClass

  mixins: [openable]

  render: ->
    (div { className: "report_overlay" },
      (div {className: @className("content")},
        (SummaryTable
          students: @props.data.allSequenceAnswers
          questions: @props.questions
          hidden: @props.hideOverviewReport
          sequence: @props.data.sequence
          clickStudent: @props.onShowStudentDetails
          clickColumnHeader: @props.onShowQuestionDetails
        )
      )
    )

module.exports = SummaryOverlay

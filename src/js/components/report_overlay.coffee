require '../../css/report_overlay.styl'

React        = require 'react'
openable     = require './mixins/openable.coffee'
Report       = React.createFactory require './report.coffee'
StudentDetailsReport = React.createFactory require './student_details_report.coffee'
QuestionDetailsReport = React.createFactory require './question_details_report.coffee'

{div} = React.DOM

ReportOverlay = React.createClass

  mixins: [openable]

  render: ->
    (div {className: "report_overlay"},
      (div {className: @className("tab"), onClick: @props.toggle}, "Report")
      (div {className: @className("content")},
        (Report
          students: @props.data.students
          questions: @props.questions
          hidden: @props.hideOverviewReport
          clickStudent: @props.onShowStudentDetails
          clickColumnHeader: @props.onShowQuestionDetails
        )
        (StudentDetailsReport
          student: @props.data.selectedStudent
          questions: @props.questions
          returnClick: @props.onShowOverview
          hidden: @props.hideStudentDetailsReport
        )
        (QuestionDetailsReport
          question: @props.data.selectedQuestion
          students: @props.data.students
          returnClick: @props.onShowOverview
          hidden: @props.hideQuestionDetailsReport
        )
      )
    )


module.exports=ReportOverlay

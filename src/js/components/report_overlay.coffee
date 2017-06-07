require '../../css/report_overlay.styl'

React        = require 'react'
openable     = require './mixins/openable.coffee'
s            = require '../util/strings.coffee'
NowShowing   = require '../now_showing.coffee'
Report       = React.createFactory require './report.coffee'
StudentDetailsReport = React.createFactory require './student_details_report.coffee'
QuestionDetailsReport = React.createFactory require './question_details_report.coffee'

{div} = React.DOM

ReportOverlay = React.createClass

  mixins: [openable]

  # List of students sorted from most recently updated to least.
  # Those who have no submissions are at the bottom of the list.
  sorted_students: ->
    _.sortBy(@props.data.students, (value) ->
      if value.submissions && value.submissions.length > 0
        v = _.maxBy(value.submissions, 'created_at')
        v.created_at
      else
        0
    ).reverse()

  render: ->
    (div {className: "report_overlay"},
      (div {className: @className("content")},

        (Report
          students: @sorted_students()
          questions: @props.questions
          hidden: (@props.nowShowing != NowShowing.ShowingPageReport)
          clickStudent: @props.onShowStudentDetails
          clickColumnHeader: @props.onShowQuestionDetails
        )

        if(@props.nowShowing == NowShowing.ShowingStudentDetails)
          (StudentDetailsReport
            student: @props.data.selectedStudent
            questions: @props.questions
            returnClick: @props.onClickPageReport
            hidden:false
          )

        if(@props.nowShowing == NowShowing.ShowingQuestionDetails)
          (QuestionDetailsReport
            question: @props.data.selectedQuestion
            students: @props.data.students
            returnClick: @props.onClickPageReport
            hidden:false
          )
      )
    )


module.exports=ReportOverlay

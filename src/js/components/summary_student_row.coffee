React      = require 'react'
_          = require 'lodash'

{div, span, tr, th, td} = React.DOM

noSubmission = (questions) ->
  answers: _.map questions, -> {}

SummaryStudentRow = React.createClass
  doClick: (e) ->
    @props.onClick e, @props.student

  render: ->
    student = @props.student
    page_answers = student.page_answers
    (tr {onClick: @doClick, className: "student_row selectable"},
      (th {className: "team_name summary"}, student.name),
      for page, page_idx in page_answers
        key = "#{student.name}#{page_idx}"
        (td {className: "answerblock", key: "#{key}-answerblock"},
          (div {className:"flex-cell", key: "#{key}-cell"},
            _.map page.answers?.answers, (a, idx) ->
              max_score = a.max_score || 6
              score = a.score
              answer = a.answer
              if answer != null
                className = "marker complete"
              else
                className = "marker incomplete"
              if a.feedback_type == "CRater::FeedbackItem"
                className += " score_#{score} max_score_#{max_score}"
                return (div {key: idx, className: className}, "#{score}")
              return ""
            if !page.submissions || page.submissions.length < 1
              [
                (div {key: "incomplete-1", className: "marker incomplete"}, '')
                (div {key: "incomplete-2", className: "marker incomplete"}, '')
                (div {key: "no-tries", className: "tries none"}, '')
              ]
            else
              (div {className: "tries", key: "#{key}-tries"}, page.submissions.length)
          )
        )
    )


module.exports=SummaryStudentRow

React      = require 'react'
_          = require 'lodash'

{div, span, tr, th, td} = React.DOM

noSubmission = (questions) ->
  answers: _.map questions, -> {}

StudentRow = React.createClass
  doClick: (e) ->
    @props.onClick e, @props.student

  render: ->
    student = @props.student
    lastSubmission = _.last(student.submissions) or noSubmission(@props.questions)
    (tr {onClick: @doClick, className: "student_row selectable"},
      (th {className: "team_name"}, student.name),
      for a, idx in lastSubmission.answers
        max_score = a.max_score || 6
        score = a.score
        answer = a.answer
        if answer?
          className = "marker complete"
        else
          className = "marker incomplete"
        if score?
          className += " score_#{score} max_score_#{max_score}"
          scoreDiv = (span {className: "score_#{score}"}, "#{score}")
        else
          scoreDiv = (span {}, "")
        (td {key: student.name + idx},
          (div {className: className}, scoreDiv)
        )
      (td {},
        if !student.submissions || student.submissions.length < 1
          (span {className: "tries none"}, '')
        else
          (span {className: "tries"}, student.submissions.length)
      )
    )


module.exports=StudentRow

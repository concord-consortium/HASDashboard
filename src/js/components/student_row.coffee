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
        if a.answer?
          className = "marker complete"
        else
          className = "marker incomplete"
        if a.score?
          className += " score_#{a.score + 1}"
          score = (span {className: "score_#{a.score + 1}"}, a.score + 1)
        else
          score = (span {}, "")
        (td {key: student.name + idx},
          (div {className: className}, score)
        )
      (td {},
        if !student.submissions || student.submissions.length < 1
          (span {className: "tries none"}, '')
        else
          (span {className: "tries"}, student.submissions.length)
      )
    )


module.exports=StudentRow

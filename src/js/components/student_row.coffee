React      = require 'react'
_          = require 'lodash'

{div, span, tr, th, td} = React.DOM

noSubmission = ->
  {
    answers: [
      {}
      {}
      {}
      {}
    ]
  }

StudentRow = React.createClass
  doClick: (e) ->
    @props.onClick e, @props.data

  render: ->
    data = @props.data
    lastSubmission = _.last(data.submissions) or noSubmission()
    (tr {onClick: @doClick, className: "student_row selectable"},
      (th {className: "team_name"}, data.student),
      for a, idx in lastSubmission.answers
        if a.answer?
          className = "marker complete"
        else
          className = "marker incomplete"
        if a.score?
          className += " score_#{a.score}"
          score = (span {className: "score_#{a.score}"}, a.score)
        else
          score = (span {}, "")
        (td {key: data.key + idx},
          (div {className: className}, score)
        )
      (td {},
        if data.submissions.length < 1
          (span {className: "tries none"}, '')
        else
          (span {className: "tries"}, data.submissions.length)
      )
    )


module.exports=StudentRow

React      = require 'react'
_          = require 'lodash'

{div, span, tr, th, td} = React.DOM

noSubmission = ->
  {
    answers: [
      {score: false}
      {score: false}
      {score: false}
      {score: false}
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
      #_.map lastSubmission.answers, (a) ->
        if a.score != false
          className = "marker complete"
          className += " " + "score_#{a.score}"
          score = (span {className: "score_#{a.score}"}, a.score)
        else
          className = "marker incomplete"
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

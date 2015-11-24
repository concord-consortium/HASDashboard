React      = require 'react'
_          = require 'lodash'

{div, span, tr, th, td} = React.DOM

StudentRow = React.createClass
  getDefaultProps: ->
    teamName: "Sue & Jim", answers: [
      {number: "10", completed: true, score: false}
      {number: "11", completed: true, score: 4}
      {number: "12", completed: true, score: false}
      {number: "13", completed: true, score: 4}
    ]

  render: ->
    (tr {className: "student_row selectable"},
      (th {}, @props.teamName),
      _.map @props.answers, (a) ->
        if a.completed
          className = "marker complete"
        else
          className = "marker incomplete"
        if a.score
          score = (span {className: "score_#{a.score}"}, a.score)
        else
          score = (span {}, "")
        (td {},
          (div {className: className}, score)
        )
    )


module.exports=StudentRow

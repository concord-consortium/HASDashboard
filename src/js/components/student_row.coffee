React      = require 'react'
_          = require 'lodash'

{div, span, tr, th, td} = React.DOM

noAnswer = ->
  [
    {number: "10", completed: false, score: false}
    {number: "11", completed: false, score: false}
    {number: "12", completed: false, score: false}
    {number: "13", completed: false, score: false}
  ]
StudentRow = React.createClass
  getDefaultProps: ->
    data:
      teamName: "No Name", answers: [[ noAnswer() ]]

  render: ->
    data = @props.data
    lastAnswer = _.last(data.answers) or noAnswer()
    (tr {onClick: @props.onClick, className: "student_row selectable"},
      (th {}, data.teamName),
      _.map lastAnswer, (a) ->
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
      (td {}, data.answers.length)
    )


module.exports=StudentRow

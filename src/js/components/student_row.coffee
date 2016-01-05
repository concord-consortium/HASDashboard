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

  doClick: (e) ->
    @props.onClick e, @props.data

  render: ->
    data = @props.data
    lastAnswer = _.last(data.answers) or noAnswer()
    (tr {onClick: @doClick, className: "student_row selectable"},
      (th {className: "team_name"}, data.teamName),
      _.map lastAnswer, (a) ->
        if a.completed
          className = "marker complete"
          if a.score
            className += " " + "score_#{a.score}"
        else
          className = "marker incomplete"
        if a.score
          score = (span {className: "score_#{a.score}"}, a.score)
        else
          score = (span {}, "")
        (td {},
          (div {className: className}, score)
        )
      (td {},
        if data.answers.length < 1
          (span {className: "tries none"}, '')
        else
          (span {className: "tries"}, data.answers.length)
      )
    )


module.exports=StudentRow

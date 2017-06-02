React      = require 'react'
_          = require 'lodash'

{div, th} = React.DOM

SummaryColumnHeader = React.createClass

  doClick: (e) ->
    @props.onClick e, @props.data

  render: ->
    pageName = @props.name
    questions  = @props.questions
    (th {className: 'answerblock'},
      (div {className: 'page-summary flex-cell'}, _.truncate(pageName, {length: 20} ))
      (div {className: 'question-summary flex-cell'},
        _.map questions, (q,i) ->
          if (i%2 == 0)
            (div {key: q.index, className: 'question-head'}, q.index)
          else
            ""
        (div {className: 'question-head'}, 'try')
      )

    )

module.exports=SummaryColumnHeader

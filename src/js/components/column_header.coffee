React      = require 'react'
_          = require 'lodash'

{div, th} = React.DOM

ColumnHeader = React.createClass

  doClick: (e) ->
    @props.onClick e, @props.data

  render: ->
    data = @props.data
    (th {}, (div {onClick: @doClick, className: 'question-number marker selectable'}, data))

module.exports=ColumnHeader

require '../../css/scrollable.styl'

React = require 'react'
{a, div, h2} = React.DOM

Scrollable = React.createClass
  render: ->
    (div {className: "scrollable"},
      (div {className: "fixed-header"},
        if @props.returnClick
          (a {className: "return", onClick: @props.returnClick}, "⬅ back")
        if @props.header
          @props.header
      )
      (div {className: "scrollable-content"},
        @props.children
      )
    )

module.exports = Scrollable

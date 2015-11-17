React = require 'react'
require '../../css/nav_overlay.styl'

{div} = React.DOM

Nav = React.createClass

  getDefaultProps: -> {}

  render: ->
    (div {className: "nav_overlay"}, "TOC")

module.exports=Nav

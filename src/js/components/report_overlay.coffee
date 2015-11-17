React = require 'react'
require '../../css/report_overlay.styl'

{div} = React.DOM

Report = React.createClass

  getDefaultProps: -> {}

  render: ->
    (div {className: "report_overlay"}, "Report")

module.exports=Report

require '../../css/report.styl'

React    = require 'react'

{div} = React.DOM

Report = React.createClass

  render: ->
    (div {className: "report"})


module.exports=Report

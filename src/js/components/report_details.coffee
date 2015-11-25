# require '../../css/report_overlay.styl'

React         = require 'react'

{div, a} = React.DOM

ReportDetails = React.createClass


  render: ->
    className = "report_details"
    className = "#{className} hidden-right" if @props.hidden
    (div {className: className},
      (a
        className: 'return'
        onClick: @props.returnClick
        ,
        '⬅ back'
      )
      (div {className: 'x'},
        "This is the content here.."
      )
    )

module.exports=ReportDetails

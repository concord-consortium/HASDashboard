require '../../css/report_overlay.styl'

React         = require 'react'
openable     = require './mixins/openable.coffee'
Report       = React.createFactory require './report.coffee'
ReportDetails = React.createFactory require './report_details.coffee'

{div} = React.DOM

ReportOverlay = React.createClass

  mixins: [openable]

  getDefaultProps: ->
    showDetails: false

  render: ->
    (div {className: "report_overlay"},
      (div {className: @className("tab"), onClick: @props.toggle}, "Report")
      (div {className: @className("content")},
        (Report
          data: @props.data
          hidden: @props.showDetails is true
          clickStudent: @props.toggleDetails
        )
        (ReportDetails
          data: @props.data.details
          returnClick: @props.toggleDetails
          hidden: @props.showDetails is false
        )
      )
    )

module.exports=ReportOverlay

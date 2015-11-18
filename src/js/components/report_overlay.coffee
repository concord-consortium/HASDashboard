require '../../css/report_overlay.styl'

React    = require 'react'
openable = require './mixins/openable.coffee'
Report   = React.createFactory require './report.coffee'
{div} = React.DOM

ReportOverlay = React.createClass

  mixins: [openable]

  render: ->

    (div {className: "report_overlay"},
      (div {className: @className("tab"), onClick: @props.toggle}, "Report")
      (div {className: @className("content")},
        (Report {data: @props.data})
      )
    )

module.exports=ReportOverlay

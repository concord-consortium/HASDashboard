React = require 'react'
require '../../css/activity_background.styl'

ActivityBackround = React.createFactory require './activity_background.coffee'
NavOverlay        = React.createFactory require './nav_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'

{h1, iframe, div} = React.DOM

App = React.createClass

  getDefaultProps: ->
    activityId: 3857

  render: ->
    src = "http://authoring.concord.org/activities/#{@props.activityId}/"

    (div {className: "app"},
      (ActivityBackround {})
      (ReportOverlay {})
      (NavOverlay {})
    )


module.exports=App

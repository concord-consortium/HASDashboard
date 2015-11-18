React = require 'react'
require '../../css/activity_background.styl'

ActivityBackround = React.createFactory require './activity_background.coffee'
NavOverlay        = React.createFactory require './nav_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'

{h1, iframe, div} = React.DOM

App = React.createClass

  getInitialState: ->
    activityId: 3857
    showReport: false
    showNav: false
    reportData: {}
    navData: {}

  toggleReport: ->
    @setState
      showReport: (not @state.showReport)

  toggleNav: ->
    @setState
      showNav: (not @state.showNav)

  render: ->

    (div {className: "app"},
      (ActivityBackround
        activityId: @state.activityId
      )
      (ReportOverlay
        opened: @state.showReport
        toggle: @toggleReport
        data: @state.reportData
      )
      (NavOverlay
        opened: @state.showNav
        toggle: @toggleNav
        data: @state.navData
      )
    )


module.exports=App

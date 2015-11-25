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
    showDetails: false
    reportData: {}
    navData: {}

  toggleReport: ->
    showReportNext = not @state.showReport
    showNavNext    = @state.showNav and (not showReportNext)
    @setState
      showReport: showReportNext
      showNav: showNavNext

  toggleNav: ->
    showNavNext    = not @state.showNav
    showReportNext = @state.showReport and (not showNavNext)
    @setState
      showReport: showReportNext
      showNav: showNavNext

  toggleDetails: ->
    @setState
      showDetails: (not @state.showDetails)

  render: ->

    (div {className: "app"},
      (ActivityBackround
        activityId: @state.activityId
      )
      (ReportOverlay
        opened: @state.showReport
        toggle: @toggleReport
        toggleDetails: @toggleDetails
        showDetails: @state.showDetails
        data: @state.reportData
      )
      (NavOverlay
        opened: @state.showNav
        toggle: @toggleNav
        data: @state.navData
      )
    )


module.exports=App

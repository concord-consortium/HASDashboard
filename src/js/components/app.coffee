React = require 'react'
$ = require 'jquery'

require '../../css/activity_background.styl'

ActivityBackround = React.createFactory require './activity_background.coffee'
NavOverlay        = React.createFactory require './nav_overlay.coffee'
ReportOverlay     = React.createFactory require './report_overlay.coffee'
Students          = require '../data/students.coffee'

{h1, iframe, div} = React.DOM

App = React.createClass

  componentDidMount: ->
    @setActivity(652)
    @setOffering(3)

  getDefaultProps: ->
    # baseUrl: "http://authoring.concord.org/"
    baseUrl: "http://localhost:3000"
    offeringBase: "http://localhost:9000/api/v1/dashboard_reports/report.js?offering_id="

  setOffering: (id) ->
    setOffering = (data) =>
      console.log data

    $.ajax
      url: "#{@props.offeringBase}#{id}"
      dataType: "jsonp"
      success: setOffering.bind(@)

  setActivity: (id) ->
    tocUrl  = "#{@props.baseUrl}/activities/#{id}/dashboard_toc"
    setActivity = (activity) =>
      first_page = activity.pages[0]
      @setState
        activity: activity
        pageUrl: "#{@props.baseUrl}/#{first_page.url}"


    $.ajax
      url: tocUrl
      dataType: "jsonp"
      success: setActivity.bind(@)

  getInitialState: ->
    pageUrl: "http://localhost:3000/activities/652"
    showReport: false
    showNav: false
    showDetails: false
    selectedStudent: null
    students: Students
    activity: {}

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

  toggleDetails: (evt,student)->
    @setState
      selectedStudent: student
      showDetails: (not @state.showDetails)

  setPage: (page_url) ->
    @setState
      pageUrl: "#{@props.baseUrl}/#{page_url}"

  render: ->

    (div {className: "app"},
      (ActivityBackround
        pageUrl: @state.pageUrl
      )
      (ReportOverlay
        opened: @state.showReport
        toggle: @toggleReport
        toggleDetails: @toggleDetails
        showDetails: @state.showDetails
        data: @state
      )
      (NavOverlay
        opened: @state.showNav
        toggle: @toggleNav
        activity: @state.activity
        setPage: @setPage
      )
    )


module.exports=App

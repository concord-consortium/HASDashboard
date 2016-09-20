require '../../css/nav_overlay.styl'

React    = require 'react'
Openable = require './mixins/openable.coffee'
Toc      = React.createFactory require './toc.coffee'

{div} = React.DOM

Nav = React.createClass

  mixins: [Openable]
  getInitialState: ->
    activity: null

  componentDidUpdate: (prevProps) ->
    if (prevProps.pageId != @props.pageId) || (prevProps.sequence != @props.sequence)
      @openActivity()

  openActivity: () ->
    if @props.pageId
      if @props.sequence
        activities = @props.sequence.activities || []
        found = _.find(activities, (a) =>
          _.find(a.pages, (p) => p.id == @props.pageId)
        )
        if found
          @setState
            activity: found.id



  render: ->
    (div {className:"nav_overlay"},
      (div {className: @className("tab"), onClick: @props.toggle}, "TOC")
      (div {className: @className("content")},
        (Toc {
          sequence: @props.sequence
          students: @props.students
          setPage: @props.setPage
          pageId: @props.pageId
          selectedActivity: @state.activity
          selectActivity: (act_id) =>
            if act_id is @state.activity
              @setState(activity: null)
            else
              @setState(activity: act_id)
          }
        )
      )
    )

module.exports=Nav

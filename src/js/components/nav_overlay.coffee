require '../../css/nav_overlay.styl'

React    = require 'react'
Openable = require './mixins/openable.coffee'
Toc      = React.createFactory require './toc.coffee'
Navigation = require '../navigation_manager.coffee'

{div} = React.DOM

Nav = React.createClass

  className: (previousClassName="fixMe") ->
    console.log @props.navigationManager.nowShowing
    console.log Navigation.ShowingToc
    if @props.navigationManager.nowShowing==Navigation.ShowingToc
      "#{previousClassName} open"
    else
      previousClassName

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
    actions = {
      selectActivity: (act_id) =>
        if act_id is @state.activity
          @setState(activity: null)
        else
          @setState(activity: act_id)
    }
    tocProps = _.assign({}, @props, @state, actions)
    clickNavTab = @props.navigationManager.onClickNav.bind(@props.navigationManager)
    (div {className:"nav_overlay shadow"},
      (div {className: @className("tab"), onClick: clickNavTab}, "TOC")
      (div {className: @className("content")},
        (Toc tocProps)
      )
    )

module.exports=Nav

require '../../css/nav_overlay.styl'

React    = require 'react'
Openable = require './mixins/openable.coffee'
Toc      = React.createFactory require './toc.coffee'

{div} = React.DOM

Nav = React.createClass

  mixins: [Openable]
  getInitialState: ->
    activity: null

  render: ->
    (div {className:"nav_overlay"},
      (div {className: @className("tab"), onClick: @props.toggle}, "TOC")
      (div {className: @className("content")},
        (Toc {
          sequence: @props.sequence
          students: @props.students
          setPage: @props.setPage
          activity: @state.activity
          setActivity: (act_id) =>
            if act_id is @state.activity
              @setState(activity: null)
            else
              @setState(activity: act_id)
          }
        )
      )
    )

module.exports=Nav

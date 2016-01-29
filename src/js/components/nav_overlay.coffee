require '../../css/nav_overlay.styl'

React    = require 'react'
Openable = require './mixins/openable.coffee'
Toc      = React.createFactory require './toc.coffee'

{div} = React.DOM

Nav = React.createClass

  mixins: [Openable]

  render: ->
    (div {className:"nav_overlay"},
      (div {className: @className("tab"), onClick: @props.toggle}, "TOC")
      (div {className: @className("content")},
        (Toc {activity: @props.activity, students: @props.students, setPage: @props.setPage})
      )
    )

module.exports=Nav

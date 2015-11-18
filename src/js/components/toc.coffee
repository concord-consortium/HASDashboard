require '../../css/toc.styl'

React    = require 'react'

{div} = React.DOM

Toc = React.createClass

  render: ->
    (div {className: "TOC"})


module.exports=Toc

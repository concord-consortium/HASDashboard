require '../../css/toc.styl'

React = require 'react'

{div, h3, ul, li, a} = React.DOM

Toc = React.createClass
  render: ->
    activity = @props.activity
    (div {className: "TOC"},
      (h3 {}, activity?.name)
      (ul {},
        _.map activity?.pages, (p, indx) =>
          onClick = (e) =>
            e.preventDefault()
            @props.setPage(p.id, p.url)
          (li  {key: p.id},
            (a {href: p.url, onClick: onClick}, p.name or "Page #{indx+1}")
          )
      )
    )


module.exports=Toc

require '../../css/toc.styl'

React    = require 'react'

{div, h3, ol, ul, li, a} = React.DOM

Toc = React.createClass

  getDefaultProps: ->
    activity:
      name: "Fake Activity"
      pages: [
        name: "Fake page"
        elemenents: []
        url: ""
      ]

  render: ->
    activity = @props.activity
    (div {className: "TOC"},
      (h3 {}, activity.name)
      (ul {},
        _.map activity.pages, (p, indx) =>
          onClick = (e) =>
            e.preventDefault()
            @props.setPage(p.url)
          (li  {},
            (a {href: p.url, onClick: onClick}, p.name or "Page #{indx+1}")
          )
      )
    )


module.exports=Toc

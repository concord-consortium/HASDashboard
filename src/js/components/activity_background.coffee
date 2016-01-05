require '../../css/activity_background.styl'

$     = require '../vendor/jquery.min.js'
React = require('react')

{h1, iframe, div} = React.DOM

ActivityBackround = React.createClass

  getDefaultProps: ->
    pageUrl: "http://authoring.concord.org/activities/3857"

  scrollIframe: (e) ->
    console.log e
    e.stopPropagation()
    e.preventDefault()

  componentDidMount: ->
    $(document).scroll  @scrollIframe

  render: ->
    src = @props.pageUrl

    (div {className: "iframeBG"},
      (div {className: "iframeContainer", ref: 'overlay'},
        (div {},
          "Hello there!")
        (iframe
          src: src,
          className: 'iframeBG',
          ref: 'frame'
        )
      )
      (div {className: "iframeOverlay"})
    )


module.exports=ActivityBackround

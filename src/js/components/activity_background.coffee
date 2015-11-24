require '../../css/activity_background.styl'

$     = require '../vendor/jquery.min.js'
React = require('react')

{h1, iframe, div} = React.DOM

ActivityBackround = React.createClass

  getDefaultProps: ->
    activityId: 3857
    authoringUrl: "http://authoring.concord.org/activities/"

  scrollIframe: (e) ->
    console.log e
    e.stopPropagation()
    e.preventDefault()

  componentDidMount: ->
    $(document).scroll  @scrollIframe

  render: ->
    src = "#{@props.authoringUrl}#{@props.activityId}/"

    (div {className: "iframeBG"},
      (div {className: "iframeContainer", ref: 'overlay'},
        (iframe
          src: src,
          className: 'iframeBG',
          ref: 'frame'
        )
      )
      (div {className: "iframeOverlay"})
    )


module.exports=ActivityBackround
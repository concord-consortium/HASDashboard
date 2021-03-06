require '../../css/activity_background.styl'

$     = require '../vendor/jquery.min.js'
React = require('react')

{iframe, div} = React.DOM

ActivityBackround = React.createClass
  getDefaultProps: ->
    pageUrl: "http://authoring.concord.org/activities/3857"

  scrollIframe: (e) ->
    e.stopPropagation()
    e.preventDefault()

  componentDidMount: ->
    $(document).scroll  @scrollIframe

  render: ->
    src = @props.pageUrl

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

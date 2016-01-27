React = require 'react'
{img} = React.DOM

ScoreImage = React.createClass
  getDefaultProps: ->
    score: 1
    width: 'auto'

  getSrc: ->
    # Display something for -1 too (test score).
    score = if @props.score > 0 then @props.score else 1
    "http://authoring.concord.org/assets/c-rater/#{score}-5pt-scale.png"

  render: ->
    (img
      className: 'score-value'
      src: @getSrc()
      alt: @props.score
      style: width: @props.width
    )

module.exports = ScoreImage

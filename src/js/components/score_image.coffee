React = require 'react'
{img} = React.DOM

ScoreImage = React.createClass
  getDefaultProps: ->
    score: 1
    width: 'auto'

  getSrc: ->
    # Display something for -1 too (test score).
    score = if @props.score then @props.score else 0
    max_score = if @props.max_score then @props.max_score else 6
    "./images/c-rater/#{score}-#{max_score}pt-scale.png"

  render: ->
    (img
      className: 'score-value'
      src: @getSrc()
      alt: @props.score
      style: width: @props.width
    )

module.exports = ScoreImage

require '../../css/histogram.styl'

React = require 'react'
_ = require 'lodash'

{div, h3, p, strong} = React.DOM

Histogram = React.createClass
  render: ->
    className = 'histogram'
    counts = @props.counts
    colors = @props.colors
    total = _.reduce(counts, (sum, item) ->
      sum + item
    , 0)
    keyClasses = "key"
    if @props.largeLegend == true
      keyClasses = "#{keyClasses} large"
    (div {className: className},
      _.map(counts, (count, key) ->
        perc = ((count / total) * 100).toFixed(0)
        (div {className:"category score_#{key}"},
          (div {className:keyClasses }, key)
          (div {className:"percent"}, "#{perc}%")
          (div {className:"bar-box"},
            (div {className:"bar score_#{key}", style: {width: "#{perc}%"}})
          )
        )
      )
    )



module.exports=Histogram

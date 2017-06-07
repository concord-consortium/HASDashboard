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
      sum + item.count
    , 0)
    (div {className: className},
      _.map(counts, (item) ->
        perc = ((item.count / total) * 100).toFixed(0)
        (div {className:"category score_#{item.value}"},
          (div {className:"count" }, item.value)
          (div {className:"bar-box"},
            (div {className:"bar score_#{item.value}", style: {width: "#{perc}%"}})
          )
          (div {className:"percent"}, "#{perc}%")
        )
      )
    )



module.exports=Histogram

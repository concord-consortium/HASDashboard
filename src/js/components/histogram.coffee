require '../../css/histogram.styl'

React = require 'react'
_ = require 'lodash'
StudentsCount = React.createFactory require './students_count.coffee'

{div, h3, p, strong} = React.DOM

Histogram = React.createClass
  renderHead: (studentMap)->
    students = _.map studentMap, (s) -> {name: s}
    (div {style: {fontSize: "10pt", color:"white" }},
      (StudentsCount {students: students, small: false})
    )


  render: ->
    className = 'histogram'
    { classes, colors}  = @props
    total = _.reduce(classes, (sum, item) ->
      sum + item.length
    , 0)
    keyClasses = "key"
    if @props.largeLegend == true
      keyClasses = "#{keyClasses} large"
    (div {className: className},
      _.map(classes, (count, key) =>
        perc = ((count.length / total) * 100).toFixed(0)
        (div {className:"category score_#{key}"},
          (div {className:keyClasses }, key)
          @renderHead(count)
          (div {className:"percent"}, "#{perc}%")
          (div {className:"bar-box"},
            (div {className:"bar score_#{key}", style: {width: "#{perc}%"}})
          )
        )
      )
    )



module.exports=Histogram

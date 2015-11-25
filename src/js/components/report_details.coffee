# require '../../css/report_overlay.styl'

React         = require 'react'

{div, p, hr, a} = React.DOM

ReportDetails = React.createClass

  getDefaultProps: ->
    data:
      teamName: "no team"
      answers: []

  render: ->
    className = "report_details"
    className = "#{className} hidden-right" if @props.hidden
    teamName = @props.data?.teamName || 'No Team'
    answers = @props.data?.answers || []

    renderAnswer = (answer) ->
      _.map answer, (ans) ->
        (div {className: 'x'},
          (hr {})
          "Try #n"
          (div {className: 'x'},
            (p {}, "Question: #{ans.number}")
            (p {}, "Answer:   #{ans.answer}")
            (p {}, "Score:    #{ans.score}")
          )
        )

    (div {className: className},
      (a
        className: 'return'
        onClick: @props.returnClick
        ,
        "⬅ back"
      )
      (hr {})
      (div {className: "teamName"}, teamName)
      _.map answers, renderAnswer

    )

module.exports=ReportDetails

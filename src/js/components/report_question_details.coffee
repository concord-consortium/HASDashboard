React = require 'react'

{a, div, h2, h3, h4, hr, p, span, strong} = React.DOM

ReportQuestionDetails = React.createClass

  getDefaultProps: ->
    data:
      teamName: "no team"
      answers: []
      try: 1

  render: ->
    className = "report_question_details"
    className = "#{className} hidden-right" if @props.hidden
    teamName = @props.data?.teamName || 'No Team'
    answers = ''
    console.log('hi ' + @props)
    try_count = 0

    renderQuestion = (answer) ->
      try_count++ # increment try count
      _.map answer, (ans) ->
        (div {className: 'x'},
          (div {className: 'x'},
            (div {className: 'question-hdr'},
              (h4 {}, "Question \##{ans.number}")
            )
            (div {className: 'question-bd'},
              (p {}, "#{ans.prompt}")
              (p {}, 
                (strong {}, "Answer:")
                " #{ans.answer}"
              )
              if ans.score != false
                (p {}, 
                  (strong {}, "Score:")
                  (span {className: "score-value score-#{ans.score}"}, " #{ans.score}")
                )
              )
            )
          )

    (div {className: className},
      (a
        className: 'return'
        onClick: @props.returnClick
        ,
        "⬅ back"
      )
      (div {className: "teamName"}, 
        (h2 {}, "Question \#")
      )
      _.map answers, renderQuestion
    )


module.exports=ReportQuestionDetails

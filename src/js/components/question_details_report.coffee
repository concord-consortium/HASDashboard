React = require 'react'

{a, div, h2, h3, h4, hr, p, span, strong} = React.DOM

QuestionDetailsReport = React.createClass

  getDefaultProps: ->
    data:
      number: "0"
      prompt: "No Question"
      answers: []  # {team, score, completed, answer}

  render: ->
    className = "report_question_details"
    question = @props.data

    (div {className: className},
      (a
        className: 'return'
        onClick: @props.returnClick
        ,
        "⬅ back"
      )
      if question
        (div {className: 'x'},
          (div {className: 'x'},
            (div {className: 'question-hdr'},
              (h4 {}, "Question \##{question.number}")
            )
            (div {className: 'question-bd'},
              (p {}, "#{question.prompt}")
              (p {},
                (strong {}, "Ansers:")
                _.map question.answers, (answer) ->
                  (div {},
                    (div {}, answer.team)
                    if answer.score != false
                      (p {},
                        (strong {}, "Score:")
                        (span {className: "score-value score-#{answer.score}"}, " #{answer.score}")
                      )
                  )
              )
            )
          )
        )
      else
        (div {} , "empty")
    )


module.exports=QuestionDetailsReport

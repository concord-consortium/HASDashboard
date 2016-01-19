React = require 'react'
_ = require 'lodash'

{a, div, h4, p, span, strong} = React.DOM

QuestionDetailsReport = React.createClass

  getDefaultProps: ->
    question:
      index: 0
      prompt: "No Question"
    runs: []

  answers: ->
    result = []
    question = @props.question
    _.each @props.runs, (run) ->
      finalSubmission = _.last run.submissions
      if finalSubmission
        _.each finalSubmission.answers, (a) ->
          if a.question_index == question.index
            answer =
              studentName: run.student_name
              studentUsername: run.student_username
              answer: a.answer
              score: a.score
            result.push answer
    result

  render: ->
    className = "report_question_details"
    question = @props.question

    (div {className: className},
      (a
        className: 'return'
        onClick: @props.returnClick
        ,
        "⬅ back"
      )
      if question
        (div {key: question.index, className: 'x'},
          (div {className: 'x'},
            (div {className: 'question-hdr'},
              (h4 {}, "Question \##{question.index}")
            )
            (div {className: 'question-bd'},
              (p {}, "#{question.prompt}")
              (p {},
                (strong {}, "Answers:")
                _.map @answers(), (answer) ->
                  (div {key: answer.studentUsername},
                    (strong {}, answer.studentName)
                    (div {}, answer.answer)
                    if answer.score?
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

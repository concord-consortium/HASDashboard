require '../../css/question_details_report.styl'

React = require 'react'
_ = require 'lodash'
Scrollable = React.createFactory require './scrollable.coffee'
ScoreImage = React.createFactory require './score_image.coffee'

{div, h3, p, strong} = React.DOM

QuestionDetailsReport = React.createClass

  getDefaultProps: ->
    question:
      index: 0
      prompt: "No Question"
    students: []

  getAnswers: ->
    result = []
    question = @props.question
    _.each @props.students, (student) ->
      finalSubmission = _.last student.submissions
      if finalSubmission
        _.each finalSubmission.answers, (a) ->
          if a.question_index == question.index
            answer =
              studentName: student.name
              answer: a.answer
              score: a.score
            result.push answer
    result

  render: ->
    className = "question-details"
    className += " hidden-right" if @props.hidden
    question = @props.question
    header = if question? then "Question \##{question.index}" else "No question"
    answers = if question? then @getAnswers() else []

    (div {className: className},
      (Scrollable {returnClick: @props.returnClick, header: header},
        if question
          (div {className: "question-details-content"},
            (div {}, question.prompt)
            (h3 {}, "Answers")
            _.map answers, (answer) ->
              (div {key: answer.studentName, className: "answer"},
                (strong {}, answer.studentName)
                (div {}, answer.answer)
                if answer.score?
                  (p {},
                    (strong {}, "Score:")
                    (ScoreImage {score: answer.score, width: "50%", height: "35px"})
                  )
              )

          )
      )
    )


module.exports=QuestionDetailsReport

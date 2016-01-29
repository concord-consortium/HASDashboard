require '../../css/question_details_report.styl'

React = require 'react'
_ = require 'lodash'
Scrollable = React.createFactory require './scrollable.coffee'
ScoreImage = React.createFactory require './score_image.coffee'

{div, h3, p, strong} = React.DOM

QuestionDetailsReport = React.createClass
  getAnswers: ->
    return [] unless @props.question?
    result = []
    _.each @props.students, (student) =>
      finalSubmission = _.last student.submissions
      return unless finalSubmission?
      a = _.find finalSubmission.answers, (a) => a.question_index == @props.question.index
      answer =
        studentName: student.name
        group: finalSubmission.group
        groupId: finalSubmission.group_id
        createdAt: finalSubmission.created_at
        answer: a.answer
        score: a.score
      result.push answer
    # Remove duplicate answers that have been submitted within the same group.
    # _.uniqueId has to be used, as otherwise all the answers with groupId == null would be
    # reduced to single one by _.uniq.
    result = _.uniq result, (a) -> if a.groupId? then a.groupId else _.uniqueId('individual-student')
    _.sortBy(result, 'createdAt').reverse()

  getHeader: ->
    if @props.question? then "Question \##{@props.question.index}" else "No question"

  render: ->
    className = "question-details"
    className += " hidden-right" if @props.hidden
    answers = @getAnswers()

    (div {className: className},
      (Scrollable {returnClick: @props.returnClick, header: @getHeader()},
        if @props.question?
          (div {className: "question-details-content"},
            (div {}, @props.question.prompt)
            (h3 {}, if answers.length > 0 then "Answers" else "No answers")
            _.map answers, (answer) ->
              (div {key: answer.studentName, className: "answer"},
                (strong {}, answer.studentName)
                if answer.group
                  (strong {}, ", " + answer.group.join(", "))
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

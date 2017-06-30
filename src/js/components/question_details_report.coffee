require '../../css/question_details_report.styl'

React = require 'react'
_ = require 'lodash'
Scrollable = React.createFactory require './scrollable.coffee'
ScoreImage = React.createFactory require './score_image.coffee'
Histogram  = React.createFactory require './histogram.coffee'

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

  getCounts: (answers)->
    counts = {}
    # Group by score:
    if (@props.question.index % 2) == 0
      counts = { "0":[], "1":[], "2":[], "3":[], "4":[], "5":[],"6":[] }
      _.each answers, (a) ->
        counts[a.score].push a.studentName

    # Group by answer
    else
      choices =  @props.question.choices || []
      _.each choices, (choice) ->
        counts[_.truncate(choice,10)] = []
      _.each answers, (a) ->
        answer = _.truncate(a.answer,10)
        counts[answer] ||= []
        counts[answer].push a.studentName
    return counts

  getHeader: ->
    if @props.question
      (div {className: "question"},
        (div {className: "number"},"Question \##{@props.question.index}")
        (div {className: "prompt"}, @props.question.prompt)
      )
    else
      "No Question"


  render: ->
    className = "question-details"
    className += " hidden-right" if @props.hidden
    answers = @getAnswers()
    max_score = 6
    counts  = @getCounts(answers)
    answers = _.sortBy(answers, 'answer')
    answers = _.sortBy(answers, 'score')
    largeLegend = (@props.question.index % 2) != 0
    (div {className: className},
      (Scrollable {returnClick: @props.returnClick, header: @getHeader()},
        (Histogram {classes:counts , largeLegend: largeLegend, colors:{0: 'red', 1: 'blue', 2:'green', 3:'yellow', default: 'gray'}})
        if @props.question?
          (div {className: "question-details-content"},
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

React      = require 'react'
_          = require 'lodash'

{div, span, tr, th, td} = React.DOM

noSubmission = (questions) ->
  answers: _.map questions, -> {}

SummaryStudentRow = React.createClass
  openStudentPage: (page) ->
    pageId = page.page
    if pageId
      @props.onClick @props.student.username, page.page

  render: ->
    student = @props.student
    allSequenceAnswers = student.allSequenceAnswers
    questionPages = @props.questions
    notAnsweredRow = [{},{}]
    openStudentPage = @openStudentPage

    (tr {className: "student_row selectable"},
      (th {className: "team_name summary"}, student.name),
      _.map questionPages, (page, page_idx) ->
        key = "#{student.name}#{page_idx}"
        clickHandler = () -> openStudentPage(page)
        page = allSequenceAnswers[page_idx] || {answers: notAnsweredRow}
        (td {className: "answerblock", key: "#{key}-answerblock"},
          (div {onClick: clickHandler, className:"flex-cell", key: "#{key}-cell"},
            _.map page.answers, (a, idx) ->
              max_score = a.max_score || 6
              score = a.score
              answer = a.answer
              if answer != null
                className = "marker complete"
              else
                className = "marker incomplete"
              if a.feedback_type == "CRater::FeedbackItem"
                className += " score_#{score} max_score_#{max_score}"
                return (div {key: idx, className: className}, "#{score}")
              return ""
            if page.tryCount? < 1
              [
                (div {key: "incomplete-1", className: "marker incomplete"}, '')
                (div {key: "incomplete-2", className: "marker incomplete"}, '')
                (div {key: "no-tries", className: "tries none"}, '')
              ]
            else
              (div {className: "tries", key: "#{key}-tries"}, page.tryCount)
          )
        )
    )


module.exports=SummaryStudentRow

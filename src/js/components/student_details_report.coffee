require '../../css/student_details_report.styl'

React = require 'react'
_ = require 'lodash'
Scrollable = React.createFactory require './scrollable.coffee'
ScoreImage = React.createFactory require './score_image.coffee'

{div, h3, h4, p, span, strong} = React.DOM

StudentDetailsReport = React.createClass
  render: ->
    className = "student-details"
    className += " hidden-right" if @props.hidden
    studentName = @props.student?.name || 'No Student'
    studentHeader = (div {className: "studentName"}, studentName)
    submissions = _.sortBy(@props.student?.submissions || [], 'created_at').reverse()
    question = {}
    _.each @props.questions, (q) ->
      question[q.index] = q

    renderGroup = (group) ->
      return '' unless group
      (span {className: 'group-members'}, "with #{group.join(', ')}")

    renderSubmission = (submission, tryCount) ->
      (div {key: submission.id, className: 'try'},
        (div {},
          (h3 {},
            "Try #{tryCount}"
            renderGroup submission.group
          )
        )
        _.map submission.answers, (ans) ->
          (div {key: ans.question_index, className: 'x'},
            (div {className: 'x'},
              (div {className: 'question-hdr'},
                (h4 {}, "Question \##{ans.question_index}")
              )
              (div {className: 'question-bd'},
                (p {}, "#{question[ans.question_index].prompt}")
                (p {},
                  (strong {}, "Answer:")
                  " #{ans.answer}"
                )
                if ans.score?
                  (p {},
                    (strong {}, "Score:")
                    (ScoreImage {score: ans.score, max_score: ans.max_score, width: "100%"})
                  )
              )
            )
          )
        )

    (div {className: className},
      (Scrollable {returnClick: @props.returnClick, header: studentHeader},
        for submission, idx in submissions
          renderSubmission submission, submissions.length - idx
      )
    )


module.exports=StudentDetailsReport

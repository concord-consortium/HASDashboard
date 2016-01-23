# require '../../css/report_overlay.styl'

React = require 'react'
_ = require 'lodash'

{a, div, h2, h3, h4, p, span, strong} = React.DOM

StudentDetailsReport = React.createClass
  render: ->
    className = "report_details"
    className = "#{className} hidden-right" if @props.hidden
    teamName = @props.student?.student_name || 'No Team'
    submissions = _.sortBy(@props.student?.submissions || [], 'id').reverse()
    question = {}
    _.each @props.questions, (q) ->
      question[q.index] = q

    renderGroup = (group) ->
      group = _.map group, (member) -> member.name
      (div {className: 'group-members'}, "Group: #{group.join(', ')}")

    renderSubmission = (submission, tryCount) ->
      (div {key: submission.id, className: 'try'},
        (div {},
          (h3 {}, "Try " + tryCount)
          if submission.group
            renderGroup(submission.group)
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
                    (span {className: "score-value score-#{ans.score}"}, " #{ans.score}")
                  )
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
        (h2 {}, teamName)
      )
      for submission, idx in submissions
        renderSubmission submission, submissions.length - idx
    )


module.exports=StudentDetailsReport

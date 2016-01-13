# require '../../css/report_overlay.styl'

React = require 'react'
_ = require 'lodash'

{a, div, h2, h3, h4, p, span, strong} = React.DOM

StudentDetailsReport = React.createClass
  render: ->
    className = "report_details"
    className = "#{className} hidden-right" if @props.hidden
    teamName = @props.student?.student || 'No Team'
    submissions = @props.student?.submissions || []
    tryCount = 0
    question = {}
    _.each @props.questions, (q) ->
      question[q.index] = q

    renderSubmission = (submission) ->
      tryCount++ # increment try count
      (div {key: submission.id, className: 'try'},
        (h3 {}, "Try " + tryCount)
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
                if ans.score != false
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
      _.map submissions, renderSubmission
    )


module.exports=StudentDetailsReport

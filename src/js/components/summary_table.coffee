require '../../css/module_summary.styl'

React      = require 'react'
_          = require 'lodash'

helper     = require '../data/helpers.coffee'

SummaryStudentRow = React.createFactory require './summary_student_row.coffee'
SummaryColumnHeader = React.createFactory require './summary_column_header.coffee'

{div, table, tbody, th, tr, td} = React.DOM

ModuleSummary = React.createClass
  render: ->
    questions = helper.getAllQuestions(@props.sequence)
    className = "module-summary"
    (div {className: className},
      (div {className: "heading-container"})
      (div {className: "table-container"},
        (table {className:"summary"},
          (tbody {},
            (tr {},
              (th {}, "")
            )
            (tr {},
              (td {}, (div {}, ""))
              _.map questions, (question,idx) =>
                (SummaryColumnHeader
                  key: idx
                  name: question.name
                  pageId: question.pageId
                  questions: question.questions
                  setPageId: @props.setPageId
                  clickQuestion: @props.clickQuestion
                )
            )
            _.map @props.students, (student,idx) =>
              (SummaryStudentRow
                key: idx
                student: student
                questions: questions
                onClick: @props.clickStudent
              )
          )
        )


      )
    )


module.exports=ModuleSummary

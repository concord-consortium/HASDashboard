require '../../css/report.styl'

React      = require 'react'
_          = require 'lodash'
StudentRow = React.createFactory require './student_row.coffee'
ColumnHeader = React.createFactory require './column_header.coffee'

{div, table, tbody, th, tr, td} = React.DOM

Report = React.createClass
  renderNoReportMsg: ->
    (div {className: "no-report-msg"}, "Sorry! No report for this page.")

  renderStudentsTable: ->
    (table {},
      (tbody {},
        (tr {},
          (th {}, "")
          (th
            colSpan: 4
            style:
              textAlign: "center"
              fontSize: "1.2em"
          , "Questions")
          (th {}, "")
        )
        (tr {},
          (td {}, (div {}, ""))
          _.map @props.questions, (question) =>
            (ColumnHeader
              key: question.index
              data: question.index
              onClick: (evt) => @props.clickColumnHeader(evt,question)
            )
          (th {}, "Tries")
        )
        _.map @props.students, (student) =>
          (StudentRow
            key: student.name
            student: student
            questions: @props.questions
            onClick: @props.clickStudent
          )
      )
    )

  render: ->
    className = "report"
    className = "#{className} hidden-left" if @props.hidden
    (div {className: className},
      if @props.questions.length > 0
        @renderStudentsTable()
      else
        @renderNoReportMsg()
    )


module.exports=Report

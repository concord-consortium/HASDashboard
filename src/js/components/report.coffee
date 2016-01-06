require '../../css/report.styl'

React      = require 'react'
_          = require 'lodash'
StudentRow = React.createFactory require './student_row.coffee'
ColumnHeader = React.createFactory require './column_header.coffee'

{div, table, th, tr, td} = React.DOM

Report = React.createClass

  render: ->
    answers = @props.students[0].answers[0]
    #headerData = _.map answers, (answer) -> answer.number
    className = "report"
    className = "#{className} hidden-left" if @props.hidden
    (div {className: className},
      (table {},
        (tr {},
          (th {}, "")
          (th
            colSpan: 4
            style:
              "text-align": "center"
              "font-size": "1.2em"
            , "Questions")
          (th {}, "")
        )
        (tr {},
          (td {}, (div {}, ""))
          _.map @props.questions, (question) =>
            (ColumnHeader
              data: question.number
              onClick: (evt) => @props.clickColumnHeader(evt,question)
            )
          (th {}, "Tries")
        )
        _.map @props.students, (student) =>
          (StudentRow
            data: student
            onClick: @props.clickStudent
          )
      )
    )


module.exports=Report

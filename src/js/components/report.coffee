require '../../css/report.styl'

React      = require 'react'
_          = require 'lodash'
Students   = require '../data/students.coffee'
StudentRow = React.createFactory require './student_row.coffee'

{div, table, th, tr, td} = React.DOM

Report = React.createClass
  getDefaultProps: ->
    students: Students

  render: ->
    answers = @props.students[0].answers[0]
    headerData = _.map answers, (answer) -> answer.number
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
          _.map headerData, (h) ->
            (th {}, (div {className: 'marker'}, h))
          (th {}, "# tries")
        )
        _.map @props.students, (student) =>
          (StudentRow
            data: student
            onClick: @props.clickStudent
          )
      )
    )


module.exports=Report

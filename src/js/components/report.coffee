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
    answers = @props.students[0].answers
    headerData = _.map answers, (answer) -> answer.number
    (div {className: "report"},
      (table {},
        (tr {},
          (th {}, (div {}, ""))
          _.map headerData, (h) ->
            (th {}, (div {className: 'marker'}, h))
        )
        _.map @props.students, (student) ->
          (StudentRow {teamName: student.teamName, answers: student.answers})
      )
    )


module.exports=Report

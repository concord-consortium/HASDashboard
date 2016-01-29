require '../../css/toc.styl'
_ = require 'lodash'
React = require 'react'

{div, h3, ul, li, a, span} = React.DOM

Toc = React.createClass
  render: ->
    activity = @props.activity
    return (div {}) unless activity?
    pageStudents = getPageStudents @props.students
    # In the future, we can replace [activity] with sequence.activities.
    activityStudents = getActivityStudents [activity], pageStudents
    (div {className: "TOC"},
      (div {className: "activity-wrap"}, 
        (h3 {},
          (StudentsCount {students: activityStudents[activity.id]})
          activity.name
        )
        (ul {},
          _.map activity.pages, (p, indx) =>
            (li  {key: p.id},
              (StudentsCount {students: pageStudents[p.id] || []})
              (PageLink
                id: p.id
                url: p.url
                name: p.name
                index: indx + 1
                setPage: @props.setPage
              )
            )
        )
      )
    )

StudentsCount = React.createFactory React.createClass
  render: ->
    (div {className: 'students-count'},
      # Don't display 0.
      if @props.students.length > 0
        (div {},
          (div {className: 'students-count-bg'})
          (div {className: 'students-count-value'}, @props.students.length)
        )
    )

PageLink = React.createFactory React.createClass
  onClick: (e) ->
    e.preventDefault()
    @props.setPage(@props.id, @props.url)
  render: ->
    (a {href: @props.url, onClick: @onClick}, @props.name or "Page #{@props.index}")

getPageStudents = (students) ->
  _.reduce students, (result, s) ->
    result[s.lastPageId] ||= []
    result[s.lastPageId].push s
    result
  , {}

getActivityStudents = (activities, pageStudents) ->
  _.reduce activities, (result, activity) ->
    result[activity.id] = _.reduce activity.pages, (actStudents, p) ->
                            actStudents.concat(pageStudents[p.id] || [])
                          , []
    result
  , {}


module.exports=Toc

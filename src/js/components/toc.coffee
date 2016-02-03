require '../../css/toc.styl'
_ = require 'lodash'
React = require 'react'

{div, h3, ul, li, a, span} = React.DOM

Toc = React.createClass
  render: ->
    sequence = @props.sequence
    return (div {}) unless sequence?
    pageStudents = getPageStudents @props.students
    # In the future, we can replace [activity] with sequence.activities.
    acts = _.map sequence.activities, (activity, act_indx) =>
      activityStudents = getActivityStudents [activity], pageStudents
      act = @props.activity
      show_activity = act == activity.id

      className = if show_activity then "activity" else "activity hidden"
      name = _.trunc "#{act_indx + 1}: #{activity.name}", {length: 36, ommission: " …" }
      (div {className: className},
        (h3 {
          onClick: (e) => @props.setActivity(activity.id),
          onTouchEnd: (e) => @props.setActivity(activity.id) },
          (StudentsCount {students: activityStudents[activity.id]})
          name
        )
        (ul {},
          _.map activity.pages, (p, indx) =>
            (li  {key: p.id},
              (StudentsCount {students: pageStudents[p.id] || []})
              (PageLink
                id: p.id
                url: p.url
                name: "#{indx + 1}. #{p.name}"
                index: indx + 1
                setPage: @props.setPage
              )
            )
        )
      )
    return (div {className: "TOC"},
      (div {className: "activity-wrap"},
        acts or ""
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

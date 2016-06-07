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
            hasQuestion = p.questions.length > 0
            (li  {key: p.id},
              (StudentsCount {students: pageStudents[p.id] || []})
              (QuestionMarker {hasQuestion: hasQuestion})
              (PageLink
                id: p.id
                url: p.url
                current: p.id == @state?.pageId
                hasQuestions: p.questions.length > 0
                name: "#{indx + 1}. #{p.name}"
                index: indx + 1
                setPage: (id,url) =>
                  @props.setPage(id, url)
                  @setState
                    pageId: id
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
  getInitialState: ->
    showToolTip: false
  toggleToolTip: (e) ->
    if(@state.showToolTip)
      @hideToolTip()
    else
      @showToolTip(e)

  hideToolTip: ->
    @setState
      showToolTip: false
  showToolTip: (e) ->
    e.stopPropagation()
    @setState
      showToolTip: true
  render: ->
    showToolTip = @state.showToolTip
    (div {className: 'marker'},
      # Don't display 0.
      if @props.students.length > 0
        (div {className: 'students-count', onTouchEnd: @toggleToolTip, onMouseEnter: @showToolTip, onMouseLeave: @hideToolTip},
          (div {className: 'students-count-value'}, @props.students.length)
          if(showToolTip)
            (div {className: 'student-names', onTouchEnd: @hideToolTip}, _.map(@props.students, (st) =>
              (div {key: st.name}, st.name))
            )
        )
    )

QuestionMarker = React.createFactory React.createClass
  render: ->
    className = "marker question"
    content = ""
    content = "★" if  @props.hasQuestion
    (div {className: className}, content)


PageLink = React.createFactory React.createClass
  onClick: (e) ->
    e.preventDefault()
    @props.setPage(@props.id, @props.url)
  render: ->
    className = "page-link"
    className += " current" if @props.current
    (a {href: @props.url, onClick: @onClick, className: className}, @props.name or "Page #{@props.index}")

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

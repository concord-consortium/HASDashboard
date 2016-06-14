require '../../css/toc.styl'
_ = require 'lodash'
React = require 'react'

{div, h3, ul, li, a} = React.DOM

Toc = React.createClass
  getInitialState: ->
    currentPageId: null

  setPage: (id) ->
    @props.setPage id
    @setState currentPageId: id

  render: ->
    {currentPageId} = @state
    {sequence, students, selectedActivity, selectActivity} = @props
    return (div {}) unless sequence?
    pageStudents = getPageStudents students
    activityStudents = getActivityStudents sequence.activities, pageStudents
    acts = _.map sequence.activities, (activity, act_indx) =>
      actSelected = selectedActivity == activity.id
      className = if actSelected then "activity" else "activity hidden"
      name = _.trunc "#{act_indx + 1}: #{activity.name}", {length: 36, ommission: " …" }
      (div {className: className},
        (h3 {
          onClick: () => selectActivity(activity.id),
          onTouchEnd: () => selectActivity(activity.id) },
          (StudentsCount
            students: activityStudents[activity.id],
            setPage: (id) =>
              @setPage(id)
              # Show activity pages if it's not already visible.
              selectActivity(activity.id) unless actSelected
          )
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
                current: p.id == currentPageId
                hasQuestions: p.questions.length > 0
                name: "#{indx + 1}. #{p.name}"
                index: indx + 1
                setPage: @setPage
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

  onNameClick: (e, studentData) ->
    e.stopPropagation()
    {setPage} = @props
    setPage(studentData.lastPageId) if setPage

  render: ->
    {showToolTip} = @state
    {setPage} = @props
    (div {className: 'marker'},
      # Don't display 0.
      if @props.students.length > 0
        (div {className: 'students-count', onTouchEnd: @toggleToolTip, onMouseEnter: @showToolTip, onMouseLeave: @hideToolTip},
          (div {className: 'students-count-value'}, @props.students.length)
          if(showToolTip)
            (div {className: 'student-names', onTouchEnd: @hideToolTip}, _.map(@props.students, (st) =>
              (a {
                key: st.name,
                className: if setPage then 'name clickable' else 'name',
                onClick: (e) => @onNameClick(e, st)
              }, st.name))
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
    @props.setPage @props.id

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

require '../../css/toc.styl'
_ = require 'lodash'
React = require 'react'
onClickOutside = require('react-onclickoutside')

{div, h3, ul, li, a} = React.DOM

Toc = React.createClass
  getInitialState: ->
    currentPageId: null

  setPage: (id) ->
    @props.setPage id
    @setState currentPageId: id

  handleActivityClick: (e, id) ->
    e.preventDefault()
    @props.selectActivity(id)


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
      (div {className: className, key:activity.id},
        (h3 {
          onTouchTap: (e) => @handleActivityClick(e, activity.id)
          onClick: (e) => @handleActivityClick(e, activity.id),
        },
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


# onClickOutside ( https://github.com/Pomax/react-onclickoutside )
# handles closing our student list when something else is clicked..
StudentsCount = React.createFactory onClickOutside React.createClass
  getInitialState: ->
    showToolTip: false

  toggleToolTip: (e) ->
    if(@state.showToolTip)
      @hideToolTip(e)
    else
      @showToolTip(e)

  hideToolTip: (e) ->
    # preventDefault and stopPropagation are needed for touch events.
    # They ensure that click event isn't triggered and we don't trigger handlers of the parent elements
    # (e.g. activity title click handler).
    e.preventDefault()
    e.stopPropagation()
    @setState
      showToolTip: false

  showToolTip: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @setState
      showToolTip: true

  onNameClick: (e, studentData) ->
    e.preventDefault()
    e.stopPropagation()
    {setPage} = @props
    setPage(studentData.lastPageId) if setPage

  render: ->
    {showToolTip} = @state
    {setPage} = @props
    (div {className: 'marker'},
      # Don't display 0.
      if @props.students.length > 0
        (div {className: 'students-count', onClick: @toggleToolTip, onTouchTap: @toggleToolTip},
          (div {className: 'students-count-value'}, @props.students.length)
          if showToolTip
            (div {className: 'student-names'}, _.map(@props.students, (st) =>
              (a {
                key: st.name,
                className: if setPage then 'name clickable' else 'name',
                onClick: (e) => @onNameClick(e, st),
                onTouchTap: (e) => @onNameClick(e, st)
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
    (a {href: @props.url, onClick: @onClick, onTouchTap: @onClick, className: className}, @props.name or "Page #{@props.index}")

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

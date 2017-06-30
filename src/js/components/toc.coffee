require '../../css/toc.styl'
_ = require 'lodash'
React = require 'react'
ReactRouter = require 'react-router'
Link = React.createFactory(ReactRouter.Link)

{div, h3, ul, li, a} = React.DOM
StudentsCount = React.createFactory require './students_count.coffee'

Toc = React.createClass
  getInitialState: ->
    currentPageId: null

  setPage: (page) ->
    @props.navigationManager.setPage page

  handleActivityClick: (e, id) ->
    e.preventDefault()
    @props.selectActivity(id)

  render: ->
    navigationManager = @props.navigationManager
    currentPageId = navigationManager.pageId
    {sequence, students} = @props
    return (div {}) unless sequence?
    pageStudents = getPageStudents students
    activityStudents = getActivityStudents sequence.activities, pageStudents
    acts = _.map sequence.activities, (activity, act_indx) =>
      actSelected = @props.activity == activity.id
      className = if actSelected then "activity" else "activity hidden"
      name = _.truncate "#{act_indx + 1}: #{activity.name}", {length: 36, ommission: " …" }
      (div {className: className, key:activity.id},
        (h3 {
          onTouchTap: (e) => @handleActivityClick(e, activity.id)
          onClick: (e) => @handleActivityClick(e, activity.id),
        },
          (StudentsCount
            students: activityStudents[activity.id],
            setPage: (page) =>
              @setPage(page)
              # Show activity pages if it's not already visible.
              selectActivity(activity.id) unless actSelected
          )
          name
        )
        (ul {},
          _.map activity.pages, (p, indx) =>
            hasQuestion = p.questions.length > 0
            (li  {key: p.id},
              (StudentsCount {students: pageStudents[p.id] || [], small: true})
              (QuestionMarker {hasQuestion: hasQuestion})
              (PageLink
                id: p.id
                url: p.url
                current: p.id == currentPageId
                hasQuestion: hasQuestion
                name: p.name
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



QuestionMarker = React.createFactory React.createClass
  render: ->
    className = "marker question"
    content = ""
    content = "★" if  @props.hasQuestion
    (div {className: className}, content)


PageLink = React.createFactory React.createClass
  render: ->
    className = "page-link"
    className += " current" if @props.current
    div({className: className, onClick: => @props.setPage(@props) },
      (div {className: 'number'},"#{@props.index}.")
      (div {className: 'name'}, @props.name or "Page #{@props.index}")
    )

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

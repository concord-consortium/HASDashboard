require '../../css/toc.styl'
_ = require 'lodash'
React = require 'react'

{div, h3, ul, li, a, span} = React.DOM

Toc = React.createClass
  render: ->
    activity = @props.activity
    studentsOnPage = getStudentsOnPage(@props.students)
    (div {className: "TOC"},
      (h3 {}, activity?.name)
      (ul {},
        _.map activity?.pages, (p, indx) =>
          (li  {key: p.id},
            (StudentsCount
              studentsOnPage: studentsOnPage[p.id] || []
            )
            ' '
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

StudentsCount = React.createFactory React.createClass
  render: ->
    (span {className: 'students-count'}, @props.studentsOnPage.length || '') # don't display 0

PageLink = React.createFactory React.createClass
  onClick: (e) ->
    e.preventDefault()
    @props.setPage(@props.id, @props.url)
  render: ->
    (a {href: @props.url, onClick: @onClick}, @props.name or "Page #{@props.index}")

getStudentsOnPage = (students) ->
  studentsOnPage = {}
  _.each students, (s) ->
    studentsOnPage[s.lastPageId] ||= []
    studentsOnPage[s.lastPageId].push s
  studentsOnPage


module.exports=Toc

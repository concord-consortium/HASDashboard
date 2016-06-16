require '../../css/students_count.styl'
_ = require 'lodash'
React = require 'react'
onClickOutside = require('react-onclickoutside')

{div, a} = React.DOM



# onClickOutside ( https://github.com/Pomax/react-onclickoutside )
# handles closing our student list when something else is clicked..
StudentsCount = onClickOutside React.createClass

# onClickOutside without autoBind:false creates many warnings,
# see: https://github.com/Pomax/react-onclickoutside/issues/89
  autobind: false

  getInitialState: ->
    showToolTip: false

  handleClickOutside: (e) ->
    if(@state.showToolTip)
      @hideToolTip(e)

  toggleToolTip: (e) ->
    e.preventDefault()
    e.stopPropagation()
    # preventDefault and stopPropagation are needed for touch events.
    # They ensure that click event isn't triggered and we don't trigger handlers of the parent elements
    # (e.g. activity title click handler).
    if(@state.showToolTip)
      @hideToolTip(e)
    else
      @showToolTip(e)

  hideToolTip: (e) ->
    @setState
      showToolTip: false

  showToolTip: (e) ->
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
    (div {className: 'students-count-marker'},
    # Don't display 0.
      if @props.students.length > 0
        (div {className: 'students-count', onClick: @toggleToolTip.bind(@), onTouchTap: @toggleToolTip.bind(@)},
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

module.exports=StudentsCount
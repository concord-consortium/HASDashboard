React      = require 'react'
_          = require 'lodash'

ReactRouter = require 'react-router'
Link        = React.createFactory(ReactRouter.Link)
{div, th}   = React.DOM

SummaryColumnHeader = React.createClass

  clickPage: () ->
    if @props.setPageId
      @props.setPageId(@props.pageId)
    else
      console.log @props.pageId

  clickQuestion: (question) ->
    if @props.clickQuestion
      @props.clickQuestion(@props.pageId, question)
    else
      console.log "Question clicked #{@props.pageId}"

  render: ->
    pageName =  _.truncate(@props.name, {length: 20})
    pageId = @props.pageId
    questions  = @props.questions
    (th {className: 'answerblock'},
      Link( {to:"pages/#{pageId}", className: "headerLink", onClick: @clickPage },
        (div {className: 'page-summary flex-cell'}, pageName)
      )
      (div {className: 'question-summary flex-cell'},
        clickQuestion = @clickQuestion
        _.map questions, (q,i) ->
          if (i%2 == 0)
            Link( {to:"pages/#{pageId}", className: "question-head headerLink", key: q.index, onClick: () -> clickQuestion(q) },
              (div {}, q.index)
            )
          else
            ""
        (div {className: 'question-head'}, 'try')
      )

    )

module.exports=SummaryColumnHeader

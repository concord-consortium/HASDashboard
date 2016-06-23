_ = require 'lodash'

pageCounter     = 1
activityCounter = 1
questionCounter = 1

rand = (max) ->
  Math.floor(Math.random() * max) + 1

randDo = (maxCount, f) ->
  _.times(rand(maxCount), f)

addQuestions = ->
  [{
    "index": questionCounter++,
    "name": "Multiple Choice Question element",
    "prompt": "why does ..."
  }, {
    "index": questionCounter++,
    "name": null,
    "prompt": "Explain your answer."
  }, {
    "index": questionCounter++,
    "name": "Multiple Choice Question element",
    "prompt": "How certain are you about your claim based on your explanation?"
  }, {
    "index": questionCounter++,
    "name": null,
    "prompt": "Explain what influenced your certainty rating."
  }]

addPage = (activityId) ->
  pageId = pageCounter++
  "name": "Page #{pageId}",
  "id": pageId,
  "url": "/activities/#{activityId}/pages/#{pageId}",
  "questions": if Math.random() > 0.6 then addQuestions() else []

module.exports = () ->
  activityId = activityCounter++
  "name": "Fake activity #{activityId}",
  "url": "/activities/#{activityId}",
  "id": activityId,
  "pages": randDo(8, -> addPage(activityId))

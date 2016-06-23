_ = require 'lodash'
activity = require './fake_activity.coffee'
activities = []

_.times 4, (i) ->
  activities.push activity(i)

module.exports = (sequenceId) ->
  "name": "Sample Sequence"
  "url": "https://localhost:3000/sequences/#{sequenceId}"
  "activities": activities



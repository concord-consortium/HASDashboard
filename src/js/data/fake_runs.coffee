_ = require 'lodash'

randomText = require './random_text.coffee'

answers = _.times(4, (i) -> randomText("choice #{i} – ", 10))

randomAnswer =
  1: -> _.sample(answers)
  2: -> randomText()
  3: -> _.sample(answers)
  4: -> randomText()

getGroupId = ->
  result = _.random(1, 20)
  # 30% chances that there is a group (id != null).
  if result > 6 then null else result

submissionId = _.random(1, 100)
getSubmissions = (questions) ->
  _.times _.random(0, 6), ->
    id: submissionId++
    group_id: getGroupId()
    created_at: _.now() - _.random(0, 1000000)
    answers: getAnswers(questions)

getAnswers = (questions) ->
  results = []
  for question, idx in questions
    feedbackType = if idx % 2 == 0 then "Embeddable::FeedbackItem" else "CRater::FeedbackItem"
    maxScore = if idx is 1 then 6 else if idx is 3 then 4 else 0
    answerText =  randomAnswer[idx+1]()
    answer = {
      question_index: question.index
      answer: answerText
      feedback: "feedback text from c-rater here"
      feedback_type: feedbackType
      score: _.random maxScore
      max_score: maxScore
    }
    results.push answer
  results

module.exports = (students, questions, sequence) ->

  activities = _.map sequence.activities, (activity) ->
    pages = activity.pages
    _.map students, (s) ->
      endpoint_url: s.endpoint_url
      last_page_id: _.sample(pages).id
      group_id: getGroupId()
      submissions: getSubmissions(questions)
      sequence_id: sequence.id
      updated_at:  _.now() - _.random(0, 1000000)
      page_ids: _.map pages, 'id'

  _.flatten(activities)
_ = require 'lodash'

words = _.words """
flesh cobweb groan blush acceptable friendly jar spotless colorful vessel ask
harm ripe rain concentrate educated perform hellish irate escape unlock float
swing level ultra camera increase mark secret ladybug retire motion smile room
craven lumpy rain uneven group hurt rigid tongue alcoholic plot sneeze black creepy point wise
clean knee attend chess vagabond deeply flock eatable bitter pump popcorn attraction careless
jealous prefer juggle right slope cause damp stupid desire babies wash rat crook
bake baby available coordinated superb refuse connect cellar flowery first handsomely
shallow giraffe ordinary peep deadpan welcome fang store explain
"""

randomText = (prefix="", max=300, min=4)->
  length = _.random(min,max)
  "#{prefix} #{_.sample(words, length).join '' }"

answers = _.times(4, (i) -> randomText("choice #{i}:", 100))

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
  answers = []
  for question, idx in questions
    feedbackType = if idx % 2 == 0 then "Embeddable::FeedbackItem" else "CRater::FeedbackItem"
    maxScore = if idx is 1 then 6 else if idx is 3 then 4 else 0
    answer = {
      question_index: question.index
      answer: randomAnswer[_.random(1, 4)]()
      feedback: "feedback text from c-rater here"
      feedback_type: feedbackType
      score: _.random 6
      max_score: maxScore
    }
    answers.push answer
  answers

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
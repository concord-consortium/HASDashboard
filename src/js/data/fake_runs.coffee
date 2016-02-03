_ = require 'lodash'

randomText = ->
  words = _.words """
    thing word car couch bingo ipsom blarg noodle shindig cable loft energy
    snail consumption plan neighbor lease loose lost bungie dingle flog frog
    plaid spiral nixie left right center adjust liken love peace gurgle gargle
    hoseclamp pipenosel nosel nuzzle beaker clear calm lax fellow following
    business leadership synthetic vertical alignment show shoe rotation
    elevation drizzle cloudy unsteady unsure gonzo bannanas terminal telex
    smart golf gocart minibus farmer field worker pelican bird louse tick tea
    tram camel blimp exposure mountain goat flag forest gunner spectacles
    """
  length = _.random(10,300)
  _.sample(words, length).join " "

randomAnswer =
  1: ->
    answers = [
      "This is the text of Choice 1. It may contain a whole lot of text instead of a very short amount.",
      "Text of Choice 2. It may be a short amount of text.",
      "This is the text of Choice 3. It may contain a whole lot of text instead of a very short amount.",
      "Text of Choice 4. It may be a short amount of text."
    ]
    _.sample(answers)
  2: ->
    randomText()
  3: ->
    answers = [
      "Text of Choice A. It may be a short amount of text.",
      "This is the text of Choice B. It may contain a whole lot of text instead of a very short amount.",
      "Text of Choice C. It may be a short amount of text.",
      "This is the text of Choice D. It may contain a whole lot of text instead of a very short amount."
    ]
    _.sample(answers)
  4: ->
    randomText()

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
  for question, idx in questions
    question_index: question.index
    answer: randomAnswer[_.random(1, 4)]()
    feedback: "feedback"
    feedback_type: if idx % 2 == 0 then "Embeddable::FeedbackItem" else "CRater::FeedbackItem"
    score: if idx % 2 == 0 then null else _.random(1, 5)

module.exports = (students, questions, sequence) ->
  page_array = []
  _.each sequence.activities, (activity) ->
    page_array.push activity.pages
  pages = _.flatten page_array

  _.map students, (s) ->
    endpoint_url: s.endpoint_url
    last_page_id: pages[_.random(0, pages.length - 1)].id
    submissions: getSubmissions(questions)
    sequence_id: 201


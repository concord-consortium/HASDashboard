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
      max_score: maxScore
    }
    # 10% of the time don't set a score so we can see the * in the report
    if _.random(1, 10) < 9
      answer.score = _.random maxScore
    results.push answer
  results

# Random fake runs. (different for each page change)
exports.fakeRuns = (students, questions, sequence) ->
  runs = _.map sequence.activities, (activity) ->
    _.map students, (s) ->
      endpoint_url: s.endpoint_url
      last_page_id: _.sample(activity.pages).id
      group_id: getGroupId()
      submissions: getSubmissions(questions)
      sequence_id: sequence.id
      updated_at:  _.now() - _.random(0, 1000000)
      page_ids: _.map activity.pages, 'id'
  _.flatten(runs)


# Return data structured the same as the API call
# that we will make. See README.md
exports.allSequenceAnswers = (students, sequence) ->
  emptyAnswer = {answers: []}
  generateFakeRun = (student) ->
    endpoint_url = student.endpoint_url
    answers = _.flatMap sequence.activities, (act, actIndex) ->
      questionPages = _.filter(act.pages, (page) -> page.questions.length > 0)
      _.map questionPages, (page, pageIndex) ->
        submissions = getSubmissions(page.questions)
        tryCount = submissions.length
        answers = (_.last(submissions) || emptyAnswer).answers
        return {
          page: page.name
          pageId: page.id
          pageIndex: pageIndex
          tryCount: tryCount
          numQuestions: page.questions.length
          answers: answers
        }
    return {
      endpoint_url: endpoint_url,
      answers: answers
    }
  return _.map(students, generateFakeRun)
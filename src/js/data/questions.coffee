_ = require 'lodash'
students = require './students.coffee'

questions = ()->
  questions = {}
  _.each students, (student) ->
    final_answers = _.last student.answers
    if final_answers

      _.each final_answers, (answer) ->
        number = answer.number
        prompt = answer.prompt
        answer =
          team: student.teamName
          completed: answer.completed
          answer: answer.answer
          score: answer.score
        questions[number] ||= {number:number, prompt:prompt}
        questions[number]["answers"] ||= []
        questions[number]["answers"].push answer
  questions = _.values questions
  questions = _.sortBy questions, (q) ->
    parseInt(q.number)
  return questions

module.exports =
  questions()

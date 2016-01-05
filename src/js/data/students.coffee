_ = require 'lodash'
random_text = ->
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

random_team_name = ->
  names = _.words """
    Sue Jim Matt Laura Sidartha Ron Harry Luna Ginny Max Leon Eva Barny
    Esther Fin Shena Sean Alice Kareem Cala Nima Aisha Chantal Mirka Tam Min
    Shen Isaac
    """
  _.sample(names, _.random(1,2)).join " & "


random_q_10 = ->
  _.random(1,4)

  answers = [
    "This is the text of Choice 1. It may contain a whole lot of text instead of a very short amount.",
    "Text of Choice 2. It may be a short amount of text.",
    "This is the text of Choice 3. It may contain a whole lot of text instead of a very short amount.",
    "Text of Choice 4. It may be a short amount of text."
  ]
  _.sample(answers)

random_q_11 = ->
  random_text()

random_q_12 = ->
  _.random(1,4)

  answers = [
    "Text of Choice A. It may be a short amount of text.",
    "This is the text of Choice B. It may contain a whole lot of text instead of a very short amount.",
    "Text of Choice C. It may be a short amount of text.",
    "This is the text of Choice D. It may contain a whole lot of text instead of a very short amount."
  ]
  _.sample(answers)

random_q_13 = ->
  random_text()

random_answer = ->
  [
      number: "10"
      prompt: "What is your favorite color?"
      answer: random_q_10()
      completed: true
      score: false
    ,
      number: "11"
      prompt: "What is your name?"
      completed: true
      answer: random_q_11()
      score: _.random(1,5)
    ,
      number: "12"
      prompt: "Who is the president?"
      completed: true
      answer: random_q_12()
      score: false
    ,
      number: "13"
      prompt: "How do you feel right now?"
      completed: true
      answer: random_q_13()
      score: _.random(1,5)
  ]

random_answers = (min=10,max=30)->
  _.times _.random(min,max), ->
    teamName: random_team_name()
    answers: _.times _.random(0,4), -> random_answer()

module.exports =
  random_answers()
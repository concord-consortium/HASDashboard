_ = require 'lodash'

FAKE_ACTIVITY_BASE_URL = 'http://concordfake.org'

names = _.words """
    Sue Jim Matt Laura Sidartha Ron Harry Luna Ginny Max Leon Eva Barny
    Esther Fin Shena Sean Alice Kareem Cala Nima Aisha Chantal Mirka Tam Min
    Shen Isaac
    """

randomName = ->
  _.shuffle(names)
  names.pop()

students = ->
  chars = "abcdefghijklmnoprstuqwx123456789"
  _.times 10, ->
    name: randomName()
    run_key: _.sample(chars, 15).join('')

module.exports =
  # If base URL is equal to FAKE_ACTIVITY_BASE_URL,
  # app will use other fake data too (activity and runs).
  # Otherwise, it will issue real ajax requests, so you can
  # provide URL to your local LARA instance here and real run keys, e.g.:
  # activity_url: 'http://localhost:3000/activities/215'
  # students: [name: 'John', run_key: '452327fa-458c-49ee-91ed-ffbb8a203357'}]
  activity_url: "#{FAKE_ACTIVITY_BASE_URL}/activities/123"
  students: students()

  FAKE_ACTIVITY_BASE_URL: FAKE_ACTIVITY_BASE_URL

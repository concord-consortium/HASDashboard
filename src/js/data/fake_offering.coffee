_ = require 'lodash'

FAKE_ACTIVITY_BASE_URL = 'http://concordfake.org'

chars = "abcdefghijklmnoprstuqwx123456789"

names = _.words """
    Sue Jim Matt Laura Sidartha Ron Harry Luna Ginny Max Leon Eva Barny
    Esther Fin Shena Sean Alice Kareem Cala Nima Aisha Chantal Mirka Tam Min
    Shen Isaac
    """

randomName = ->
  _.sample(names, 2).join ' '

studentData = (name) ->
  name: name
  username: name.replace(' ', '').toLowerCase() + _.random(1, 1000)
  endpoint_url: _.sample(chars, 15).join('')

students = ->
  result = _.times 10, -> studentData randomName()
  # Add a few students with duplicate names.
  _.times 2, ->
    result.push studentData _.sample(result).name
  result


module.exports =
  # If base URL is equal to FAKE_ACTIVITY_BASE_URL,
  # app will use other fake data too (activity and runs).
  # Otherwise, it will issue real ajax requests, so you can
  # provide URL to your local LARA instance here and endpoint URLs.
  activity_url: "#{FAKE_ACTIVITY_BASE_URL}/activities/123"
  students: students()

  FAKE_ACTIVITY_BASE_URL: FAKE_ACTIVITY_BASE_URL

_ = require 'lodash'

exports.urlParams = ->
  query = window.location.search.substring(1)
  rawVars = query.split("&")
  params = {}
  for v in rawVars
    [key, val] = v.split("=")
    params[key] = decodeURIComponent(val)
  params

exports.fakeAjax = (callback) ->
  # Timeout so we keep things async, random to add a bit of testing.
  setTimeout ->
    callback()
  , _.random(1, 200)

exports.baseUrl = (url) ->
  a = document.createElement("a")
  a.href = url
  port = if a.port then ":#{a.port}" else ""
  "#{a.protocol}//#{a.hostname}#{port}"
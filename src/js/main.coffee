React = require 'react'
ReactDOM = require 'react-dom'
injectTapEventPlugin = require 'react-tap-event-plugin'
injectTapEventPlugin(
  shouldRejectClick: (lastTouchEventTimestamp, clickEventTimestamp) ->
    return true
)
require './init-rollbar.coffee'
require '../css/main.styl'
require '../css/normalize.min.css'
# This is a hack to watch changes in index.html too.
require '../../public/index.html'
$ = require './vendor/jquery.min.js'

App = React.createFactory require './components/app.coffee'

$(document).ready (event) ->
  elm = $('#app')[0]
  ReactDOM.render(App({}), elm)

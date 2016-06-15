require './init-rollbar.coffee'
require '../css/main.styl'
require '../css/normalize.min.css'
# This is a hack to watch changes in index.html too.
require '../../public/index.html'
$ = require './vendor/jquery.min.js'
React = require 'react'

App = React.createFactory require './components/app.coffee'

$(document).ready (event) ->
  elm = $('#app')[0]
  React.render(App({}), elm)

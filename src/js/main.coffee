React = require 'react'
ReactDOM = require 'react-dom'
ReactRouter = require 'react-router'
{ hashHistory } = ReactRouter
Router = React.createFactory(ReactRouter.Router)
Route  = React.createFactory(ReactRouter.Route)
AppClass = require './components/app.coffee'
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

App = React.createFactory(AppClass)

$(document).ready (event) ->
  elm = $('#app')[0]
  ReactDOM.render(
    Router({history: hashHistory},
      Route( {path: "/", component: App},
        Route( {path: "pages/:pageId", component: App})
      )
    ), elm
  )

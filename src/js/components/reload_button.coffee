require '../../css/reload_button.styl'
React      = require "react"

{div, table, tbody, th, tr, td} = React.DOM

ReloadButton = React.createClass
  getInitialState: ->
    loading: false

  onClick: ->
    @setState
      loading: true
    stopLoading = ()=>
      @setState
        loading: false

    if @props.onLoadComplete
      @props.onLoadComplete(stopLoading)
    else
      setTimeout(stopLoading, 2000)

  render: ->
    loading = if @state.loading then "loading" else ""
    className = "icon-reload #{loading}"
    (div {className: className, onClick: @onClick })

module.exports=ReloadButton

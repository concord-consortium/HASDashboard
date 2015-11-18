module.exports =

  getDefaultProps: ->
    opend: false
    toggle: ->
      console.log "toggled"

  className: (previousClassName = "fixme") ->
    if @props.opened
      "#{previousClassName} open"
    else
      previousClassName

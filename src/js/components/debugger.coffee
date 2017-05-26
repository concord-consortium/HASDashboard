React = require "react"

{div, span} = React.DOM

module.exports = React.createClass
  displayName: "Debugger"
  onClick: () ->
    console.log JSON.stringify(@props.data, null, "  ")

  render: () ->
    bottomStyle =
      position: "fixed"
      left: 0
      bottom: 0
      width: "100vw"
      backgroundColor: "black"
      color: "white"
      zIndex: 20000
      display: "flex"
      flexDirection: "row"
      justifyContent: "center"
    contentStyle =
      fontSize: "16pt"

    (div {style: bottomStyle},
      (span {style:contentStyle, onClick:@onClick}, "JSON state")
    )

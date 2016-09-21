React = require "react"
{div} = React.DOM


module.exports = React.createClass
  displayName: "ErrorAlert"
  message: () ->
    {error} = @props
    needLogin = error.status == 401 || error.status == 403
    if needLogin
      "  You have been logged out of the portal.
         Please close this window, login to the portal, and re-launch your report.
      "
    else
      " There was a network error. Please try refreshing this page in a few moments."

  render: () ->
    overlayStyle =
      position: "fixed"
      left: 0
      top: 0
      bottom: 0
      right: 0
      backgroundColor: 'none'
      zIndex: 6000
      display: "flex"
      justifyContent: "center"
      alignItems: "center"
    alertStyle =
      position: "relative"
      width: 500
      padding: "2em"
      backgroundColor: "hsl(0,0%,99%)"
      opacity: 1
      boxShadow: '2px 2px 4px gray'
      borderRadius: '0.4em'
    contentStyle =
      fontSize: "18pt"
      fontWeight: "bold"
      lineHeight: "1.5em"
      color: "hsl(29,50%,40%)"

    (div {style: overlayStyle},
      (div {style: alertStyle},
        (div {style: contentStyle},
          @message()
        )
      )
    )

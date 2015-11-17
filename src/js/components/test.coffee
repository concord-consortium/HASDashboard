React = require('react')
{h1} = React.DOM

class Hello extends React.Component
  render: ->
    (h1 {}, "Hello world")


module.exports=Hello

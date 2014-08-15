React = require 'react'
attachFastClick = require 'fastclick'
App = require './app/app'

attachFastClick document.body

React.renderComponent App(), document.body

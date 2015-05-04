stores = [
  require "stores/test-store.cjsx"
]

if false
  require "components/test-component.cjsx"

React = require "react"

global =
  clearAllStores: () ->
    for Store in stores
      Store.clear()

  renderComponent: (moduleName, props) ->
    Component = require moduleName
    React.renderToString React.createElement(Component, props)

  initStore: (moduleName, props) ->
    Store = require moduleName
    if Store.execFromServerSide?
      Store.execFromServerSide props

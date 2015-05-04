if false
  bulk = require "bulk-require"
  bulk "#{__dirname}/../", [
    "components/**/*.cjsx"
    "stores/**/*.cjsx"
  ]

React = require "react"

REACT_COMPONENT_ATTR = "data-react-component"
REACT_PROPS_ATTR = "data-react-props"

STORE_ATTR = "data-store"
STORE_PROPS_ATTR = "data-store-props"

hoge =
  attachComponents: ->
    nodes = document.querySelectorAll "[#{REACT_COMPONENT_ATTR}]"
    for node in nodes
      info = @getInfo node, "component"
      Component = require info.moduleName
      React.render React.createElement(Component, info.props), node

  initializeStores: ->
    nodes = document.querySelectorAll "[#{STORE_ATTR}]"
    for node in nodes
      info = @getInfo node, "store"
      Store = require info.moduleName
      if Store.execFromServerSide?
        Store.execFromServerSide info.props
      node.parentNode.removeChild node

  getInfo: (node, type) ->
    if type is "component"
      moduleNameAttr = REACT_COMPONENT_ATTR
      propsNameAttr = REACT_PROPS_ATTR
    else if type is "store"
      moduleNameAttr = STORE_ATTR
      propsNameAttr = STORE_PROPS_ATTR
    moduleName = node.getAttribute moduleNameAttr
    propsJSON = node.getAttribute propsNameAttr
    return {
      moduleName: "../" + moduleName
      props: propsJSON and JSON.parse propsJSON
    }

window.addEventListener "load", ->
  hoge.initializeStores()
  hoge.attachComponents()

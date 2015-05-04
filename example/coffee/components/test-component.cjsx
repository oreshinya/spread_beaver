React = require "react"
testStore = require "stores/test-store.cjsx"

module.exports = React.createClass
  propTypes:
    hoge: React.PropTypes.string

  getInitialState: ->
    {
      records: testStore.all()
    }

  render: ->
    <div>
      <h1>Records</h1>
      <ul>
        {
          for r in @state.records
            <li key={r.id}>Record {r.id}</li>
        }
      </ul>
      <h1>Props</h1>
      <div>hoge: {@props.hoge}</div>
    </div>

assert = require('chai').assert

TestComponent = require('react-library/lib/TestComponent')
ReactTestUtils = require('react-addons-test-utils')

SiteColumnAnswerComponent = require '../../src/answers/SiteColumnAnswerComponent'
AnswerValidator = require '../../src/answers/AnswerValidator'

React = require 'react'
ReactDOM = require 'react-dom'
R = React.createElement
H = React.DOM

class SiteContext extends React.Component
  @childContextTypes:
    selectEntity: React.PropTypes.func
    getEntityById: React.PropTypes.func
    getEntityByCode: React.PropTypes.func
    renderEntityListItemView: React.PropTypes.func
    T: React.PropTypes.func

  getChildContext: ->
    selectEntity: (options) ->
      options.callback("testid")
    getEntityById: (entityType, entityId, callback) ->
      if entityId == "testid"
        callback({
          _id: "testid"
          code: '10007'
          })
    getEntityByCode: (entityType, entityCode, callback) ->
      if entityCode == '10007'
        callback({
          _id: "testid"
          code: '10007'
        })
    renderEntityListItemView: (entityType, entity) ->
      H.div null, entity.code
    T: (str) -> str

  render: ->
    return @props.children

describe 'SiteColumnAnswerComponent', ->
  beforeEach ->
    @toDestroy = []

    @render = (options = {}) =>
      elem = R(SiteContext, {}, R(SiteColumnAnswerComponent, options))
      comp = new TestComponent(elem)
      @toDestroy.push(comp)
      return comp

  afterEach ->
    for comp in @toDestroy
      comp.destroy()

  it "selects entity", (done) ->
    testComponent = @render({
      siteType: "water_point"
      onValueChange: (value) ->
        assert.equal value.code, "10007"

        # Validate answer
        answer = {value: value}
        answerValidator = new AnswerValidator()
        question = {_type: "SiteColumnQuestion"}
        assert.equal null, answerValidator.validate(question, answer)

        done()
    })
    TestComponent.click(testComponent.findDOMNodeByText(/Select/))

  it "displays entity", (done) ->
    testComponent = @render({
      siteType: "water_point"
      value: { code: "10007" }
      onValueChange: (value) ->
    })

    _.defer () =>
      # Check for display
      assert testComponent.findDOMNodeByText(/10007/), "Should display code"
      done()

  it "clears entity", (done) ->
    testComponent = @render({
      siteType: "water_point"
      value: { code: "10007" }
      onValueChange: (value) ->
        assert not value
        done()
    })

    clearButton = ReactTestUtils.findRenderedDOMComponentWithTag(testComponent.getComponent(), 'button')
    assert clearButton
    TestComponent.click(clearButton)


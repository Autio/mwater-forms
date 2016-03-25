assert = require('chai').assert

TestComponent = require('react-library/lib/TestComponent')
ReactTestUtils = require('react-addons-test-utils')

UnitsAnswerComponent = require '../../src/answers/UnitsAnswerComponent'

React = require 'react'
ReactDOM = require 'react-dom'
R = React.createElement
H = React.DOM

describe 'UnitsAnswerComponent', ->
  beforeEach ->
    @toDestroy = []

    @render = (options = {}) =>
      elem = R(UnitsAnswerComponent, options)
      comp = new TestComponent(elem)
      @toDestroy.push(comp)
      return comp

  afterEach ->
    for comp in @toDestroy
      comp.destroy()

  it "allows changing of units", ->
    assert false

  it "defaults unit", ->
    assert false

  it "records decimal number", ->
    assert false

  it "records whole number", ->
    assert false

  it "enforces required", ->
    assert false

  it "enforces required on blank answer", ->
    assert false

  it "allows 0 on required", ->
    assert false

  it "requires unit to be specified", ->
    assert false

  it "validates range", ->
    assert false

###
  it "allows changing of units", ->
    @qview.$el.find("#quantity").val("123.4").change()
    @qview.$el.find("#units").val("a").change()
    assert.equal @model.get("q1234").value.units, "a"

    @qview.$el.find("#units").val("b").change()
    assert.equal @model.get("q1234").value.units, "b"

  it "defaults unit", ->
    @q.defaultUnits = "b"
    @qview = @compiler.compileQuestion(@q).render()

    @qview.$el.find("#quantity").val("123.4").change()
    assert.equal @model.get("q1234").value.units, "b"

  it "records decimal number", ->
    @qview.$el.find("#quantity").val("123.4").change()
    @qview.$el.find("#units").val("a").change()
    assert.equal @model.get("q1234").value.quantity, 123.4

  it "records whole number", ->
    @q.decimal = false
    @qview = @compiler.compileQuestion(@q).render()

    @qview.$el.find("#quantity").val("123.4").change()
    assert.equal @model.get("q1234").value.quantity, 123

  it "enforces required", ->
    assert @qview.validate()

    @q.required = false
    @qview = @compiler.compileQuestion(@q).render()
    assert not @qview.validate()

  it "enforces required on blank answer", ->
    @qview.$el.find("#quantity").val("response").change()
    @qview.$el.find("#quantity").val("").change()
    @qview.$el.find("#units").val("a").change()
    assert @qview.validate()

  it "allows 0 on required", ->
    @qview.$el.find("#quantity").val("0").change()
    @qview.$el.find("#units").val("a").change()
    assert not @qview.validate()

  it "requires unit to be specified", ->
    @qview.$el.find("#quantity").val("0").change()
    assert @qview.validate()

    @qview.$el.find("#units").val("a").change()
    assert not @qview.validate()


  it "validates range", ->
    @q.validations = [
      {
        op: "range"
        rhs: { literal: { max: 6 } }
        message: { _base: "es", es: "message" }
      }
    ]
    @qview = @compiler.compileQuestion(@q).render()

    @qview.$el.find("#quantity").val("7").change()
    @qview.$el.find("#units").val("a").change()
    assert.equal @qview.validate(), "message"
###
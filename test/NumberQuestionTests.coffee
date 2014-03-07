$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
assert = require('chai').assert
FormCompiler = require '../src/FormCompiler'

describe "NumberQuestion", ->
  context "compiled question", ->
    beforeEach ->
      @model = new Backbone.Model()
      @compiler = new FormCompiler(model: @model, locale: "es")
      @q = {
        _id: "1234"
        _type: "NumberQuestion"
        text: { _base: "en", en: "English", es: "Spanish" }
        required: true
        decimal: true
      }
      @qview = @compiler.compileQuestion(@q).render()

    it "displays question text"
    it "displays hint"
    it "displays help"
    it "displays required"

    it "records decimal number", ->
      @qview.$el.find("input").val("123.4").change()
      assert @model.get("1234").value == 123.4

    it "records whole number", ->
      @q.decimal = false
      @qview = @compiler.compileQuestion(@q).render()

      @qview.$el.find("input").val("123.4").change()
      assert.equal @model.get("1234").value, 123

    it "enforces required", ->
      assert @qview.validate()

      @q.required = false
      @qview = @compiler.compileQuestion(@q).render()
      assert not @qview.validate()

    it "enforces required on blank answer", ->
      @qview.$el.find("input").val("response").change()
      @qview.$el.find("input").val("").change()
      assert @qview.validate()

    it "allows 0 on required", ->
      @qview.$el.find("input").val("0").change()
      assert not @qview.validate()

    it "validates range"


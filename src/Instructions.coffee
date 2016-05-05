Backbone = require 'backbone'
_ = require 'lodash'

module.exports = class Instructions extends Backbone.View
  initialize: (options) ->
    # Save options
    @options = options || {}

    @$el.html _.template('''
      <div class="well well-small"><%=html%><%-text%></div>
      ''')(html: @options.html, text: @options.text)

    # Adjust visibility based on model if model present
    if @model?
      @listenTo(@model, "change", @updateVisibility)

    # Starts visible
    @visible = true
    if not @shouldBeVisible()
      @$el.hide()
      @visible = false

  updateVisibility: (e) ->
    # slideUp/slideDown
    if @shouldBeVisible() and not @visible
        @$el.slideDown()
    if not @shouldBeVisible() and @visible
        @$el.slideUp()
    @visible = @shouldBeVisible()

  shouldBeVisible: =>
    if not this.options.conditional
        return true
    # Test equality to handle undefined more gracefully
    return @options.conditional(this.model) == true

  setFocus: (offset) ->
    # Scroll so that it's at the top of the screen (lowered by any offset)
    # The offset is mostly used to avoid hiding it under the top banner
    $('html, body').animate({
      scrollTop: $("#" + @id).offset().top - offset
    }, 1000);
  
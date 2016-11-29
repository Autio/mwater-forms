_ = require 'lodash'
React = require 'react'
H = React.DOM
R = React.createElement

formUtils = require './formUtils'

# A group is a list of questions/other items that can have a common condition and a header
module.exports = class GroupComponent extends React.Component
  @contextTypes:
    locale: React.PropTypes.string

  @propTypes:
    group: React.PropTypes.object.isRequired # Design of group. See schema
    data: React.PropTypes.object      # Current data of response (for roster entry if in roster)
    responseRow: React.PropTypes.object    # ResponseRow object (for roster entry if in roster)
    onDataChange: React.PropTypes.func.isRequired   # Called when data changes
    isVisible: React.PropTypes.func.isRequired # (id) tells if an item is visible or not
    onNext: React.PropTypes.func.isRequired   # Called when moving out of the GroupComponent questions
    schema: React.PropTypes.object.isRequired  # Schema to use, including form

  validate: (scrollToFirstInvalid) ->
    return @refs.itemlist.validate(scrollToFirstInvalid)

  render: ->
    # To avoid circularity
    ItemListComponent = require './ItemListComponent'
      
    H.div className: "panel panel-default",
      H.div key: "header", className: "panel-heading",
        formUtils.localizeString(@props.group.name, @context.locale)

      H.div key: "body", className: "panel-body",
        R ItemListComponent,
          ref: "itemlist"
          contents: @props.group.contents
          data: @props.data
          responseRow: @props.responseRow
          onDataChange: @props.onDataChange
          isVisible: @props.isVisible
          onNext: @props.onNext
          schema: @props.schema
          

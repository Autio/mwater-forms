PropTypes = require('prop-types')
React = require 'react'
H = React.DOM
R = React.createElement

formUtils = require '../formUtils'
EntityDisplayComponent = require '../EntityDisplayComponent'

module.exports = class SiteAnswerComponent extends React.Component
  @contextTypes:
    selectEntity: PropTypes.func
    getEntityById: PropTypes.func.isRequired
    getEntityByCode: PropTypes.func.isRequired
    renderEntitySummaryView: PropTypes.func.isRequired
    T: PropTypes.func.isRequired  # Localizer to use

  @propTypes:
    value: PropTypes.object
    onValueChange: PropTypes.func.isRequired
    siteTypes: PropTypes.array

  constructor: (props) ->
    super
    
    @state = {text: props.value?.code or ""}

  componentWillReceiveProps: (nextProps) ->
    # If different, override text
    if nextProps.value?.code != @props.value?.code
      @setState(text: if nextProps.value?.code then nextProps.value?.code else "")

  focus: () ->
    @refs.input.focus()

  handleKeyDown: (ev) =>
    if @props.onNextOrComments?
      # When pressing ENTER or TAB
      if ev.keyCode == 13 or ev.keyCode == 9
        @props.onNextOrComments(ev)
        # It's important to prevent the default behavior when handling tabs (or else the tab is applied after the focus change)
        ev.preventDefault()

  getEntityType: () ->
    # Convert to new entity type
    siteType = (if @props.siteTypes then @props.siteTypes[0]) or "Water point"
    entityType = siteType.toLowerCase().replace(new RegExp(' ', 'g'), "_")
    return entityType

  handleSelectClick: () =>
    entityType = @getEntityType()

    @context.selectEntity { entityType: entityType, callback: (entityId) =>
      # Get entity
      @context.getEntityById(entityType, entityId, (entity) =>
        if not entity
          throw new Error("Unable to lookup entity #{entityType}:#{entityId}")
        if not entity.code
          alert(@props.T("Unable to select that site as it does not have an mWater ID. Please synchronize first with the server."))
          return
        @props.onValueChange(code: entity.code)
      )
    }

  handleChange: (ev) => 
    @setState(text: ev.target.value)

  handleBlur: (ev) =>
    if ev.target.value
      @props.onValueChange({ code: ev.target.value })
    else
      @props.onValueChange(null)

  render: ->
    H.div null,
      H.div className:"input-group",
        H.input 
          type: "tel"
          className: "form-control"
          onKeyDown: @handleKeyDown
          ref: 'input'
          placeholder: @context.T("mWater ID of Site")
          style: { zIndex: "inherit" } # Workaround for strange bootstrap z-index
          value: @state.text
          onBlur: @handleBlur
          onChange: @handleChange
        H.span className: "input-group-btn",
          H.button className: "btn btn-default", disabled: not @context.selectEntity?, type: "button", onClick: @handleSelectClick, style: { zIndex: "inherit" },
            @context.T("Select")
          
      H.br()
      R EntityDisplayComponent, 
        displayInWell: true
        entityType: @getEntityType()
        entityCode: @props.value?.code
        getEntityByCode: @context.getEntityByCode
        renderEntityView: @context.renderEntitySummaryView
        T: @context.T

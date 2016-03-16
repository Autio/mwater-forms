React = require 'react'
R = React.createElement
H = React.DOM
ReactDOM = require 'react-dom'
moment = require 'moment'

module.exports = class DateTimePickerComponent extends React.Component
  @propTypes:
    # do we need time picker?
    timepicker: React.PropTypes.bool

    # callback on date change
    # argument: {date: moment object for currently selected datetime, oldDate: moment object for previous datetime}
    onChange: React.PropTypes.func

    # date as moment
    date: React.PropTypes.object

    # default date as moment
    defaultDate: React.PropTypes.object

  @defaultProps:
    timepicker: false

  onChange: (event) =>
    @props.onChange?(event.date)

  componentDidMount: ->
    pickerOptions =
      format: if @props.timepicker then "YYYY-MM-DD HH-mm-ss" else "YYYY-MM-DD"
      sideBySide: true

    if @props.defaultDate
      pickerOptions.defaultDate = @props.defaultDate

    node = @refs.datetimepicker
    picker = $(node).datetimepicker(pickerOptions)

    $(node).data("DateTimePicker").date(@props.date or null)
    $(node).on("dp.change", @onChange)

  componentWillReceiveProps: (nextProps) ->
    # If unchanged
    if nextProps.date == null and @props.date == null
      return
    if nextProps.date? and @props.date? and nextProps.date.isSame(@props.date)
      return

    node = @refs.datetimepicker
    $(node).off("dp.change", @onChange)
    $(node).data("DateTimePicker").date(nextProps.date or null)
    $(node).on("dp.change", @onChange)

  componentWillUnmount: ->
    $(@refs.datetimepicker).data("DateTimePicker").destroy()

  render: ->
    H.div style: { position: "relative" },
      H.input ref: "datetimepicker", type: "text", className: "form-control", placeholder: @props.placeholder,
    # H.div ref: "datetimepicker", className: "input-group",
    #   H.span className: "input-group-addon",
    #     H.span className: "glyphicon glyphicon-calendar"
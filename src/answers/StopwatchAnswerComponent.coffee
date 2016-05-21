React = require 'react'
H = React.DOM
R = React.createElement

now = () -> new Date().getTime()
roundToTenthsOfSecond = (ticks) -> if ticks? then Math.round(ticks / 100) / 10 else null
getDisplayValue = (ticks) -> if ticks? then roundToTenthsOfSecond(ticks).toFixed(1) else "-.-"
toTicks = (seconds) -> if seconds? then seconds * 1000 else null

# Creates a stopwatch timer component on the form, can be start/stop/reset
module.exports = class StopwatchAnswerComponent extends React.Component
  @propTypes:
    onValueChange: React.PropTypes.func.isRequired
    value: React.PropTypes.number

  constructor: (props) ->
    super
    ticks = toTicks(props.value)
    @state =
      timerId: 0          # ID of the running JS timer
      elapsedTicks: ticks # Tick count

  componentWillReceiveProps: (nextProps) -> @setState(elapsedTicks: toTicks(nextProps.value))

  # Starts a timer to update @elapsedTicks every 10 ms
  handleStartClick: () =>
    startTime = now() - (@state.elapsedTicks or 0) # for restarts we need to fudge the startTime
    update = () => @setState(elapsedTicks: now() - startTime)
    @setState(timerId: setInterval(update, 10)) # create a timer and store its id in state
    @props.onValueChange(null)

  # Stores the value in seconds
  persistValue: (ticks) -> @props.onValueChange(roundToTenthsOfSecond(ticks))

  # Stops the timer and persists the value
  handleStopClick: () =>
    clearInterval(@state.timerId) # stop the running timer
    @setState(timerId: 0)
    @persistValue(@state.elapsedTicks)

  # Stops timer and resets @elapsedTicks to 0
  handleResetClick: () =>
    clearInterval(@state.timerId)
    @setState(timerId: 0, elapsedTicks: null)
    @props.onValueChange(null)

  render: ->
        isRunning = @state.timerId != 0
        H.div {},
          H.div {className: "jumbotron"},
            H.h1 {}, getDisplayValue(@state.elapsedTicks)
          H.div {className: 'btn-toolbar', role: 'toolbar'},
            H.div {className: 'btn-group', role: 'group'},
              H.button {className: 'btn btn-success', onClick: @handleStartClick, disabled: isRunning}, "Start"
              H.button {className: 'btn btn-danger', onClick: @handleStopClick, disabled: !isRunning}, "Stop"
              H.button {className: 'btn btn-default', onClick: @handleResetClick, disabled: !@state.elapsedTicks}, "Reset"
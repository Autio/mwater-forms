var DateTimePickerComponent, H, PropTypes, R, React, moment,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PropTypes = require('prop-types');

React = require('react');

R = React.createElement;

H = React.DOM;

moment = require('moment');

if (process.browser) {
  require('eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js');
}

module.exports = DateTimePickerComponent = (function(superClass) {
  extend(DateTimePickerComponent, superClass);

  function DateTimePickerComponent() {
    this.handleInputFocus = bind(this.handleInputFocus, this);
    this.onChange = bind(this.onChange, this);
    return DateTimePickerComponent.__super__.constructor.apply(this, arguments);
  }

  DateTimePickerComponent.propTypes = {
    format: PropTypes.string,
    timepicker: PropTypes.bool,
    showTodayButton: PropTypes.bool,
    showClear: PropTypes.bool,
    onChange: PropTypes.func,
    date: PropTypes.object,
    defaultDate: PropTypes.object
  };

  DateTimePickerComponent.defaultProps = {
    timepicker: false
  };

  DateTimePickerComponent.prototype.onChange = function(event) {
    var base;
    return typeof (base = this.props).onChange === "function" ? base.onChange(event.date) : void 0;
  };

  DateTimePickerComponent.prototype.componentDidMount = function() {
    return this.createNativeComponent(this.props);
  };

  DateTimePickerComponent.prototype.componentWillUnmount = function() {
    return this.destroyNativeComponent();
  };

  DateTimePickerComponent.prototype.destroyNativeComponent = function() {
    return $(this.refs.datetimepicker).data("DateTimePicker").destroy();
  };

  DateTimePickerComponent.prototype.createNativeComponent = function(props) {
    var node, picker, pickerOptions;
    pickerOptions = {
      showClear: props.showClear,
      useStrict: true,
      focusOnShow: false
    };
    if (props.format != null) {
      pickerOptions.format = props.format;
    } else if (props.timepicker) {
      pickerOptions.format = "YYYY-MM-DD HH-mm-ss";
    } else {
      pickerOptions.format = "YYYY-MM-DD";
    }
    if (props.defaultDate) {
      pickerOptions.defaultDate = props.defaultDate;
    }
    pickerOptions.showTodayButton = props.showTodayButton;
    node = this.refs.datetimepicker;
    picker = $(node).datetimepicker(pickerOptions);
    $(node).data("DateTimePicker").date(props.date || null);
    return $(node).on("dp.change", this.onChange);
  };

  DateTimePickerComponent.prototype.componentWillReceiveProps = function(nextProps) {
    var node;
    if (nextProps.format !== this.props.format) {
      this.destroyNativeComponent();
      _.defer((function(_this) {
        return function() {
          return _this.createNativeComponent(nextProps);
        };
      })(this));
      return;
    }
    if (nextProps.date === null && this.props.date === null) {
      return;
    }
    if ((nextProps.date != null) && (this.props.date != null) && nextProps.date.isSame(this.props.date)) {
      return;
    }
    node = this.refs.datetimepicker;
    $(node).off("dp.change", this.onChange);
    $(node).data("DateTimePicker").date(nextProps.date || null);
    return $(node).on("dp.change", this.onChange);
  };

  DateTimePickerComponent.prototype.handleInputFocus = function() {
    var node;
    node = this.refs.datetimepicker;
    return $(node).data("DateTimePicker").show();
  };

  DateTimePickerComponent.prototype.render = function() {
    var input;
    input = H.input({
      type: "text",
      className: "form-control",
      placeholder: this.props.placeholder,
      onFocus: this.handleInputFocus,
      style: {
        zIndex: "inherit",
        minWidth: "12em"
      }
    });
    return H.div({
      className: 'input-group date',
      ref: "datetimepicker"
    }, input, H.span({
      className: "input-group-addon",
      onClick: this.handleCalendarClick
    }, H.span({
      className: "glyphicon glyphicon-calendar"
    })));
  };

  return DateTimePickerComponent;

})(React.Component);

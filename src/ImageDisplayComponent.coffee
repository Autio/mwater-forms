React = require 'react'
H = React.DOM

# Displays an image
module.exports = class ImageDisplayComponent extends React.Component
  @propTypes:
    id: React.PropTypes.string.isRequired  # Id of image
    formCtx: React.PropTypes.object.isRequired

  constructor: ->
    super
    @state = { error: false, url: null }

  componentDidMount: ->
    # Get URL of thumbnail
    @props.formCtx.imageManager.getImageThumbnailUrl @props.id, (url) =>
      @setState(url: url, error: false)
    , => @setState(error: true)

  handleImgError: =>
    @setState(error: true)

  handleImgClick: =>
    if @props.formCtx.displayImage
      @props.formCtx.displayImage(id: @props.id)

  render: ->
    if @state.error
      src = "img/no-image-icon.jpg"
    else if @state.url
      src = @state.url
    else
      src = "img/image-loading.png"

    H.img className: "img-thumbnail", src: src, onError: @handleImgError, onClick: @handleImgClick, style: { maxHeight: 100 }

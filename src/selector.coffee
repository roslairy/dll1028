# A frame for one selection.
class SelectionFrame extends PIXI.Container

  # Frame attrs.
  FRAME_COLOR: 0xe0d4b9
  FRAME_STROKE: 4
  FRAME_WIDTH: 370
  FRAME_HEIGHT: 60
  FRAME_ROUND: 15

  # Attrs of fram animation.
  FADE_SCALE: 0
  FADE_INTERVAL: 300
  ZOOM_SCALE: 1.08
  FADE_INTERVAL: 300
  FADEIN_OFFSET: 50

  # Can't be triggered when invisible or unselectable.
  isVisible: false
  isSelectable: false

  # Callback when selected.
  cb: null

  # Construct an select frame.
  # @param FRAME_X x position.
  # @param FRAME_Y y position.
  constructor: (@FRAME_X, @FRAME_Y) ->
    super
    @position.set(@FRAME_X, @FRAME_Y)

    # Rounded square.
    @frame = new PIXI.Graphics
    @frame.lineStyle(@FRAME_STROKE, @FRAME_COLOR, 1)
    @frame.beginFill(0x0, 0)
    @frame.drawRoundedRect(
      -@FRAME_WIDTH / 2,
      -@FRAME_HEIGHT / 2,
      @FRAME_WIDTH,
      @FRAME_HEIGHT,
      @FRAME_ROUND
    )
    @frame.endFill()
    @addChild @frame

    # This invisible component is paticularly used to interact.
    # Due to unknwn bug in Tween caused by triggering interactive attribute.
    @buttonArea = new PIXI.Graphics
    @buttonArea.lineStyle(0)
    @buttonArea.beginFill(0x0, 0)
    @buttonArea.drawRect(
      -@FRAME_WIDTH / 2,
      -@FRAME_HEIGHT / 2,
      @FRAME_WIDTH,
      @FRAME_HEIGHT
    )
    @buttonArea.endFill()
    @addChild @buttonArea

    @buttonArea.interactive = true;
    @buttonArea.on('touchstart', () => @_onSelect());
    @buttonArea.on('mousedown', () => @_onSelect());

    # Text inside rounded square.
    @text = new PIXI.Text(
      '',
        font : '24px Helvetica',
        fill : 0x454545,
        align : 'center'
    )
    @_fitPositionWithText()
    @addChild @text

    @alpha = 0
    @scale.set(@FADE_SCALE, @FADE_SCALE)

  # Show frame with downward animation.
  appear: ->
    @position.set(@FRAME_X, @FRAME_Y - @FADEIN_OFFSET)
    @scale.set(1, 1)
    @alpha = 0
    scaleTween = new TWEEN.Tween(@position)
      .to({ x: @FRAME_X, y: @FRAME_Y }, @FADE_INTERVAL)
      .easing(TWEEN.Easing.Exponential.Out)
      .onComplete(() => @isVisible = true)
      .start()
    opacityTween = new TWEEN.Tween(@)
      .to({ alpha: 1 }, @FADE_INTERVAL)
      .start();
    opacityTween

  # Hide frame with fading out animation.
  disappear: ->
    scaleTween = new TWEEN.Tween(@scale)
      .to({ x: @FADE_SCALE, y: @FADE_SCALE }, @FADE_INTERVAL)
      .easing(TWEEN.Easing.Exponential.In)
      .onComplete(() => @isVisible = false)
      .start()
    opacityTween = new TWEEN.Tween(@)
      .to({ alpha: 0 }, @FADE_INTERVAL)
      .start();
    opacityTween

  # Zoom in frame when selected.
  zoomin: ->
    scaleTween = new TWEEN.Tween(@scale)
      .to({ x: @ZOOM_SCALE, y: @ZOOM_SCALE }, @FADE_INTERVAL)
      .easing(TWEEN.Easing.Quadratic.InOut)
      .start()

  # Set text for frame.
  # @param text text for frame
  setText: (text) ->
    @text.text = text
    @_fitPositionWithText()

  # Set if this frame is selecatble with a callback.
  # @param isSelectable
  # @param cb callback
  setSelectable: (isSelectable, cb) ->
    @isSelectable = isSelectable
    @cb = cb

  # When selected.
  _onSelect: ->
    if @cb isnt null and @isSelectable and @isVisible then @cb()

  # Reposition text to make it central.
  _fitPositionWithText: ->
    @text.position.x = -@text.width / 2
    @text.position.y = -@text.height / 2

# Controller for all selections.
class Selector extends PIXI.Container

  # Offset between one selection and another.
  SELECTION_OFFSET: 100
  cb: null

  # Delay for selected frame to disappear.
  SELECTION_DELAY: 1000

  # Construct an selector.
  # @param SELECTOR_X x position.
  # @param SELECTOR_Y y position.
  constructor: (@SELECTOR_X, @SELECTOR_Y) ->
    super
    @position.set(@SELECTOR_X, @SELECTOR_Y)
    @selectionA = new SelectionFrame(0, 0)
    @selectionB = new SelectionFrame(0, @SELECTION_OFFSET)
    @addChild @selectionA
    @addChild @selectionB

  # Interface to begin a selection.
  # @param selections array of selections.
  # @cb callback with arg "index of selected item".
  select: (selections, cb)->
    @cb = cb
    if selections.length >= 1
      @selectionA.setText(selections[0])
      @selectionA.setSelectable(true, () => @_onOneSelected(0))
      @selectionA.appear()
    if selections.length >= 2
      @selectionB.setText(selections[1])
      @selectionB.setSelectable(true, () => @_onOneSelected(1))
      @selectionB.appear()

  # Callback when selected.
  _onOneSelected: (index)->
    if (index is 0)
      selected = @selectionA
      another = @selectionB
    else
      selected = @selectionB
      another = @selectionA

    another.setSelectable(false, null)
    another.disappear()

    selected.zoomin()
    selected.setSelectable(false, null)

    # Delay a short period when selected.
    setTimeout(
      () =>
        selected.setSelectable(false, null)
        selected.disappear()
        @cb(index)
      ,
      @SELECTION_DELAY
    )

class SelectionFrame extends PIXI.Container

  FRAME_COLOR: 0xe0d4b9
  FRAME_STROKE: 4
  FRAME_WIDTH: 370
  FRAME_HEIGHT: 60
  FRAME_ROUND: 15

  FADE_SCALE: 0
  FADE_INTERVAL: 300

  ZOOM_SCALE: 1.08
  FADE_INTERVAL: 300

  FADEIN_OFFSET: 50

  isVisible: false
  isSelectable: false
  cb: null

  constructor: (@FRAME_X, @FRAME_Y) ->
    super
    @position.set(@FRAME_X, @FRAME_Y)

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

  zoomin: ->
    scaleTween = new TWEEN.Tween(@scale)
      .to({ x: @ZOOM_SCALE, y: @ZOOM_SCALE }, @FADE_INTERVAL)
      .easing(TWEEN.Easing.Quadratic.InOut)
      .start()

  setText: (text) ->
    @text.text = text
    @_fitPositionWithText()

  setSelectable: (isSelectable, cb) ->
    @isSelectable = isSelectable
    @cb = cb

  _onSelect: ->
    if @cb isnt null and @isSelectable and @isVisible then @cb()

  _fitPositionWithText: ->
    @text.position.x = -@text.width / 2
    @text.position.y = -@text.height / 2

class Selector extends PIXI.Container

  SELECTION_OFFSET: 100
  cb: null

  SELECTION_DELAY: 1000

  constructor: (@SELECTOR_X, @SELECTOR_Y) ->
    super
    @position.set(@SELECTOR_X, @SELECTOR_Y)
    @selectionA = new SelectionFrame(0, 0)
    @selectionB = new SelectionFrame(0, @SELECTION_OFFSET)
    @addChild @selectionA
    @addChild @selectionB

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

    setTimeout(
      () =>
        selected.setSelectable(false, null)
        selected.disappear()
        @cb(index)
      ,
      @SELECTION_DELAY
    )

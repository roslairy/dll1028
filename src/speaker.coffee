class Speaker extends PIXI.Container

  SPEAKER_X: 0
  SPEAKER_Y: 0

  FADE_SCALE: 0
  FADE_INTERVAL: 150

  DELAY_LEAST: 600
  DELAY_PER_CHAR: 50

  constructor: (@SPEAKER_X, @SPEAKER_Y) ->
    super
    @position.set(@SPEAKER_X, @SPEAKER_Y)
    @text = new PIXI.Text(
      '',
        font : '29px Helvetica',
        fill : 0x454545,
        align : 'center'
    )
    @alpha = 0
    @scale.set(0, 0)
    @addChild @text

  speak: (sentence, cb) ->
    sentence = sentence.replace("\\n", "\n")
    if (@text.text.length isnt 0)
      @_fadeout().onComplete(
        () ->
          @text.text = sentence
          @_fitPositionWithText()
          @_fadein().onComplete(
            ()-> setTimeout(cb, @DELAY_LEAST + sentence.length * @DELAY_PER_CHAR)
          )
      )
    else
      @text.text = sentence
      @_fitPositionWithText()
      tmp = { t: 0 }
      @_fadein().onComplete(
            ()-> setTimeout(cb, @DELAY_LEAST + sentence.length * @DELAY_PER_CHAR)
      )

  disappear: ->
    @_fadeout().onComplete(
      () ->
        @text.text = ''
    )

  _fitPositionWithText: ->
    @text.position.x = -@text.width / 2
    @text.position.y = -@text.height / 2

  _fadein: ->
    scaleTween = new TWEEN.Tween(@scale)
        .to({ x: 1, y: 1 }, @FADE_INTERVAL)
        .easing(TWEEN.Easing.Exponential.Out)
        .start()
    opacityTween = new TWEEN.Tween(@)
        .to({ alpha: 1 }, @FADE_INTERVAL)
        .start();
    opacityTween

  _fadeout: ->
    scaleTween = new TWEEN.Tween(@scale)
        .to({ x: @FADE_SCALE, y: @FADE_SCALE }, @FADE_INTERVAL)
        .easing(TWEEN.Easing.Exponential.In)
        .start()
    opacityTween = new TWEEN.Tween(@)
        .to({ alpha: 0 }, @FADE_INTERVAL)
        .start();
    opacityTween

  _fadeoutAndFadein: ->

# To show what AI says.
class Speaker extends PIXI.Container

  # Attrs of speaker.
  SPEAKER_X: 0
  SPEAKER_Y: 0

  # Attrs of animation.
  FADE_SCALE: 0
  FADE_INTERVAL: 150

  # Attrs of delay that sentence keeps showing.
  DELAY_LEAST: 600
  DELAY_PER_CHAR: 50

  # Construct an speaker.
  # @param SPEAKER_X x position.
  # @param SPEAKER_Y y position.
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

  # Speak a sentence.
  # @param sentence
  # @cb callback
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

  # Hide speaker.
  disappear: ->
    @_fadeout().onComplete(
      () ->
        @text.text = ''
    )

  # Reposition text to make it central.
  _fitPositionWithText: ->
    @text.position.x = -@text.width / 2
    @text.position.y = -@text.height / 2

  # Fade in speaker.
  _fadein: ->
    scaleTween = new TWEEN.Tween(@scale)
        .to({ x: 1, y: 1 }, @FADE_INTERVAL)
        .easing(TWEEN.Easing.Exponential.Out)
        .start()
    opacityTween = new TWEEN.Tween(@)
        .to({ alpha: 1 }, @FADE_INTERVAL)
        .start();
    opacityTween

  # Fade out speaker.
  _fadeout: ->
    scaleTween = new TWEEN.Tween(@scale)
        .to({ x: @FADE_SCALE, y: @FADE_SCALE }, @FADE_INTERVAL)
        .easing(TWEEN.Easing.Exponential.In)
        .start()
    opacityTween = new TWEEN.Tween(@)
        .to({ alpha: 0 }, @FADE_INTERVAL)
        .start();
    opacityTween

  # Legacy.
  _fadeoutAndFadein: ->

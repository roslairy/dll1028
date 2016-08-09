# Avatar of the AI.
class Avatar extends PIXI.Container

  # Attrs of circle graphic.
  CIRCLE_COLOR: 0xf38bb2;
  CIRCLE_RADIUS: 70;

  # Attrs of square graphic.
  SQUARE_COLOR: 0x1ba7b2;
  SQUARE_WIDTH: 120;

  # Attrs of triangle graphic.
  TRIANGLE_COLOR: 0xa2abb4;
  TRIANGLE_WIDTH: 140;

  # Attrs of animation which make avatar fade from one graphic to another.
  FADE_SCALE: 0.0
  FADE_INTERVAL: 240

  # Interval of animation which reset position and rotation of Avatar
  # while changing graphic of Avatar.
  RESET_INTERVAL: 500

  # Delay of animation callback.
  ANIM_DELAY: 500

  # Attrs of up-down roaming animation.
  UPDOWN_HIGH: 100
  UPDOWN_LOW: -100
  UPDOWN_INTERVAL: 1000

  # Attrs of left-right roaming animation.
  LEFTRIGHT_LEFT: -100
  LEFTRIGHT_RIGHT: 100
  LEFTRIGHT_INTERVAL: 1000

  # Attrs of infinity-symbol roaming animation.
  INFINITY_SYMBOL_X_OFFSET: 100
  INFINITY_SYMBOL_Y_OFFSET: 50
  INFINITY_SYMBOL_INTERVAL: 800

  # Attrs of pendulum rotation animation.
  PENDULUM_DEGREE: 30
  PENDULUM_INTERVAL: 1000

  # Attrs of circle rotation animation.
  ROTATE_CIRCLE_INTERVAL: 1600

  # Constants for moods.
  MOOD_EXCITED: 0
  MOOD_HAPPY: 1
  MOOD_AMAZED: 2
  MOOD_SAD: 3
  MOOD_FEARFUL: 4
  MOOD_SHY: 5
  MOOD_ABHOR: 6
  MOOD_ANGRY: 7

  # Collect tweens in order to clean them respectively.
  actionTweens: []
  rotateTweens: []

  # Construct an avatar.
  # @param AVATAR_X x position.
  # @param AVATAR_Y y position.
  constructor: (@AVATAR_X, @AVATAR_Y)->
    super
    @position.x = @AVATAR_X
    @position.y = @AVATAR_Y
    @_initCircle()
    @_initSquare()
    @_initTriangle()
    @currentGraphic = @circle

  # Show avatar from invisible state with pop up animation.
  # This will change graphic to circle.
  # @param cb callback of animation.
  appear: (cb) ->
    @_fadein(@circle)
    setTimeout(cb, @ANIM_DELAY / 2)

  # Hide avatar with pop down animation.
  # @param cb callback of animation.
  disappear: (cb) ->
    @_fadeout(@currentGraphic)
    setTimeout(cb, @ANIM_DELAY / 2)

  # Alter mood of avatar.
  # @param mood constants for moods.
  # @param cb callback of animation.
  alterMood: (mood, cb) ->
    switch mood
      when @MOOD_EXCITED
        @_changeToGraphic(@circle)
        @_moveUpDown()
        @_rotateStill()
      when @MOOD_HAPPY
        @_changeToGraphic(@circle)
        @_moveInfinitySymbol()
        @_rotateStill()
      when @MOOD_AMAZED
        @_changeToGraphic(@square)
        @_moveInfinitySymbol()
        @_rotatePendulum()
      when @MOOD_SAD
        @_changeToGraphic(@square)
        @_moveStill()
        @_rotatePendulum()
      when @MOOD_FEARFUL
        @_changeToGraphic(@square)
        @_moveUpDown()
        @_rotateCircle()
      when @MOOD_SHY
        @_changeToGraphic(@circle)
        @_moveUpDown()
        @_rotateStill()
      when @MOOD_ABHOR
        @_changeToGraphic(@triangle)
        @_moveUpDown()
        @_rotateStill()
      when @MOOD_ANGRY
        @_changeToGraphic(@triangle)
        @_moveUpDown()
        @_rotateCircle()
      else
        @_changeToGraphic(@circle)
        @_moveUpDown()
        @_rotateCircle()
    setTimeout(cb, @ANIM_DELAY)

  # Change graphic with animation.
  _changeToGraphic: (graphic) ->
    if (@currentGraphic isnt graphic) then @_alterGraphic(graphic)

  # Run reset position animtaion followed by an external animation.
  _resetPosAndRun: (animation)->
    resetPosTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X, y: @AVATAR_Y }, @RESET_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
        .chain(animation)
        .start()
    @actionTweens.push(resetPosTween)

  # Run up-down roaming animation.
  _moveUpDown: ->
    @_clearActionTween()
    upTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X, y: @AVATAR_Y - @UPDOWN_HIGH }, @UPDOWN_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    downTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X, y: @AVATAR_Y - @UPDOWN_LOW }, @UPDOWN_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    # Chain each other to loop.
    upTween.chain(downTween)
    downTween.chain(upTween)
    @actionTweens.push(upTween)
    @actionTweens.push(downTween)
    @_resetPosAndRun(upTween)

  # Run left-right roaming animation.
  _moveLeftRight: ->
    @_clearActionTween()
    leftTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X + @LEFTRIGHT_LEFT, y: @AVATAR_Y }, @LEFTRIGHT_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    rightTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X + @LEFTRIGHT_RIGHT, y: @AVATAR_Y }, @LEFTRIGHT_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    # Chain each other to loop.
    leftTween.chain(rightTween)
    rightTween.chain(leftTween)
    @actionTweens.push(leftTween)
    @actionTweens.push(rightTween)
    @_resetPosAndRun(leftTween)

  # Run infinity-symbol roaming animation.
  _moveInfinitySymbol: ->
    @_clearActionTween()
    rightBottomTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X + @INFINITY_SYMBOL_X_OFFSET, y: @AVATAR_Y + @INFINITY_SYMBOL_Y_OFFSET }, @INFINITY_SYMBOL_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    rightTopTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X + @INFINITY_SYMBOL_X_OFFSET, y: @AVATAR_Y - @INFINITY_SYMBOL_Y_OFFSET }, @INFINITY_SYMBOL_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    leftBottomTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X - @INFINITY_SYMBOL_X_OFFSET, y: @AVATAR_Y + @INFINITY_SYMBOL_Y_OFFSET }, @INFINITY_SYMBOL_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    leftTopTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X - @INFINITY_SYMBOL_X_OFFSET, y: @AVATAR_Y - @INFINITY_SYMBOL_Y_OFFSET }, @INFINITY_SYMBOL_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    # Chain each other to loop.
    rightBottomTween.chain(rightTopTween)
    rightTopTween.chain(leftBottomTween)
    leftBottomTween.chain(leftTopTween)
    leftTopTween.chain(rightBottomTween)
    @actionTweens.push(rightBottomTween)
    @actionTweens.push(rightTopTween)
    @actionTweens.push(leftBottomTween)
    @actionTweens.push(leftTopTween)
    @_resetPosAndRun(rightBottomTween)

  # Keep still in position.
  _moveStill: ->
    @_clearActionTween()
    stillTween = new TWEEN.Tween(@position)
        .to({ x: @AVATAR_X, y: @AVATAR_Y }, 0)
    @actionTweens.push(stillTween)
    @_resetPosAndRun(stillTween)

  # Clear all running tweens of roaming.
  _clearActionTween: ->
    TWEEN.remove(@actionTweens.pop()) while @actionTweens.length > 0

  # Run reset rotation animtaion followed by an external animation.
  _resetRotAndRun: (animation)->
    resetRotTween = new TWEEN.Tween(@)
        .to({ rotation: 0 }, @RESET_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
        .chain(animation)
        .start()
    @rotateTweens.push(resetRotTween)

  # Run circle rotation animation.
  _rotateCircle: ->
    @_clearRotationTween()
    circleTween = new TWEEN.Tween(@)
        .to({ rotation: Math.radians 360 }, @ROTATE_CIRCLE_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
        .onComplete(
          () => @rotation = 0
        )
    circleTween.chain(circleTween)
    @rotateTweens.push(circleTween)
    @_resetRotAndRun(circleTween)

  # Run pendulum rotation animation.
  _rotatePendulum: ->
    @_clearRotationTween()
    reverseTween = new TWEEN.Tween(@)
        .to({ rotation: Math.radians @PENDULUM_DEGREE }, @PENDULUM_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    forwardTween = new TWEEN.Tween(@)
        .to({ rotation: Math.radians(-@PENDULUM_DEGREE) }, @PENDULUM_INTERVAL)
        .easing(TWEEN.Easing.Quadratic.InOut)
    # Chain each other to loop.
    reverseTween.chain(forwardTween)
    forwardTween.chain(reverseTween)
    @rotateTweens.push(reverseTween)
    @rotateTweens.push(forwardTween)
    @_resetRotAndRun(reverseTween)

  # Keep still in rotation.
  _rotateStill: ->
    @_clearRotationTween()
    stillTween = new TWEEN.Tween(@)
        .to({ rotation: Math.radians 0 }, 0)
    @rotateTweens.push(stillTween)
    @_resetRotAndRun(stillTween)

  # Clear all running tweens of rotation.
  _clearRotationTween: ->
    TWEEN.remove(@rotateTweens.pop()) while @rotateTweens.length > 0

  # Run altering graphic animation.
  _alterGraphic: (graphic) ->
    # Move the current graphic to top surface.
    # To make altering animation more obvious.
    @removeChild @currentGraphic
    @addChild @currentGraphic
    @_fadein graphic
    @_fadeout @currentGraphic
    @currentGraphic = graphic

  # Run fading in animation for one paticular graphic.
  _fadein: (graphic) ->
    scaleTween = new TWEEN.Tween(graphic.scale)
        .to({ x: 1, y: 1 }, @FADE_INTERVAL)
        .easing(TWEEN.Easing.Quintic.Out)
        .start()
    opacityTween = new TWEEN.Tween(graphic)
        .to({ alpha: 1 }, @FADE_INTERVAL)
        .start();

  # Run fading out animation for one paticular graphic.
  _fadeout: (graphic) ->
    scaleTween = new TWEEN.Tween(graphic.scale)
        .to({ x: @FADE_SCALE, y: @FADE_SCALE }, @FADE_INTERVAL)
        .easing(TWEEN.Easing.Quintic.In)
        .start()
    opacityTween = new TWEEN.Tween(graphic)
        .to({ alpha: 0 }, @FADE_INTERVAL)
        .start();

  # Initialize circle graphic.
  _initCircle: ->
    @circle = new PIXI.Graphics
    @circle.lineStyle 0
    @circle.beginFill(@CIRCLE_COLOR, 1)
    @circle.drawCircle(0, 0, @CIRCLE_RADIUS)
    @circle.endFill()
    @circle.scale.set(@FADE_SCALE, @FADE_SCALE)
    @circle.alpha = 0;
    @addChild @circle

  # Initialize square graphic.
  _initSquare: ->
    @square = new PIXI.Graphics
    @square.lineStyle 0
    @square.beginFill(@SQUARE_COLOR, 1)
    @square.drawRect(-@SQUARE_WIDTH / 2, -@SQUARE_WIDTH / 2, @SQUARE_WIDTH, @SQUARE_WIDTH)
    @square.endFill()
    @square.scale.set(@FADE_SCALE, @FADE_SCALE)
    @square.alpha = 0;
    @addChild @square

  # Initialize triangle graphic.
  _initTriangle: ->
    @triangle = new PIXI.Graphics
    @triangle.lineStyle 0
    @triangle.beginFill(@TRIANGLE_COLOR, 1)
    square3 = Math.sqrt(3)
    @triangle.moveTo(0, -@TRIANGLE_WIDTH / square3);
    @triangle.lineTo(-@TRIANGLE_WIDTH / 2, @TRIANGLE_WIDTH / 2 / square3);
    @triangle.lineTo(@TRIANGLE_WIDTH / 2, @TRIANGLE_WIDTH / 2 / square3);
    @triangle.endFill()
    @triangle.scale.set(@FADE_SCALE, @FADE_SCALE)
    @triangle.alpha = 0;
    @addChild @triangle

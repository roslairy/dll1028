class Stage extends PIXI.Container

  STAGE_WIDTH: 640
  STAGE_HEIGHT: 1024

  AVATAR_X: 320
  AVATAR_Y: 260

  SPEAKER_X: 320
  SPEAKER_Y: 580

  SELECTOR_X: 320
  SELECTOR_Y: 780

  constructor: ->
    super
    @width = @STAGE_WIDTH
    @height = @STAGE_HEIGHT

    @avatar = new Avatar(@AVATAR_X, @AVATAR_Y)
    @addChild(@avatar)
    @selector = new Selector(@SELECTOR_X, @SELECTOR_Y)
    @addChild @selector
    @speaker = new Speaker(@SPEAKER_X, @SPEAKER_Y)
    @addChild @speaker

    # @testg1 = new PIXI.Graphics
    # @testg1.lineStyle 0
    # @testg1.beginFill(0x000000, 1)
    # @testg1.drawCircle(300, 1000, 30)
    # @testg1.endFill()
    # @testg1.interactive = true;
    # @testg1.on('touchstart', ()=>@avatar.alterMood(@avatar.MOOD_AMAZED));
    # @addChild @testg1
    #
    # @testg = new PIXI.Graphics
    # @testg.lineStyle 0
    # @testg.beginFill(0x000000, 1)
    # @testg.drawCircle(200, 1000, 30)
    # @testg.endFill()
    # @testg.interactive = true;
    # @testg.on('touchstart', ()=> @avatar.alterMood(@avatar.MOOD_EXCITED));
    # @addChild @testg
    #
    # @testg2 = new PIXI.Graphics
    # @testg2.lineStyle 0
    # @testg2.beginFill(0x000000, 1)
    # @testg2.drawCircle(100, 1000, 30)
    # @testg2.endFill()
    # @testg2.interactive = true;
    # @testg2.on('touchstart', ()=> @avatar.alterMood(@avatar.MOOD_ABHOR));
    # @addChild @testg2
    #
    # @testg3 = new PIXI.Graphics
    # @testg3.lineStyle 0
    # @testg3.beginFill(0x000000, 1)
    # @testg3.drawCircle(400, 1000, 30)
    # @testg3.endFill()
    # @testg3.interactive = true;
    # @testg3.on('touchstart', ()=> @selector.select(selections, (index)->console.log("select #{index}")));
    # @addChild @testg3
    #
    # @testg4 = new PIXI.Graphics
    # @testg4.lineStyle 0
    # @testg4.beginFill(0x000000, 1)
    # @testg4.drawCircle(500, 1000, 30)
    # @testg4.endFill()
    # @testg4.interactive = true;
    # @testg4.on('touchstart', ()=> @speaker.speak("So who on earth are you?"));
    # @addChild @testg4
    #
    # @testg5 = new PIXI.Graphics
    # @testg5.lineStyle 0
    # @testg5.beginFill(0x000000, 1)
    # @testg5.drawCircle(600, 1000, 30)
    # @testg5.endFill()
    # @testg5.interactive = true;
    # @testg5.on('touchstart', ()=> );
    # @addChild @testg5
    @

  scaleToSize: (width, height) ->
    @scale.x = width / @STAGE_WIDTH
    @scale.y = height / @STAGE_HEIGHT

  alterMood: (mood, cb) ->
    @avatar.alterMood(mood, cb)

  speak: (sentence, cb) ->
    @speaker.speak(sentence, cb)

  avatarAppear: (cb) ->
    @avatar.appear(cb)

  avatarDisappear: (cb) ->
    @avatar.disappear(cb)

  select: (selections, cb) ->
    @selector.select(selections, cb)

  update: (time)->

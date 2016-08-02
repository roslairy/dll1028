class Plot

  PLOT_PATH: 'dist/microsoft.plot'
  DEAFULT_PLOT_TITLE: 'default'

  ALTER_MOOD_DELAY: 1000

  subplots: {}
  curPlot: null
  curLineIdx: 0

  constructor: ->
    @stage = new Stage
    @_loadPlot()

  scaleToSize: (width, height) ->
    @stage.scaleToSize(width, height)

  update: (time)->

  paint: (renderer)->
    renderer.render(@stage)

  _loadPlot: ()->
    PIXI.loader
      .add('plot', @PLOT_PATH)
      .load(
        (loader, resources) =>
          @_parsePlot(resources)
          @_runPlot()
      );

  _parsePlot: (resources)->
    plotstr = resources.plot.data
    plotlines = plotstr.split("\n")
    curTitle = ''
    curContent = []
    for line in plotlines
      matchResult = line.match(/\[(\w+)\]/)
      if matchResult isnt null and matchResult.length >= 2
        title = matchResult[1]
        if title isnt 'end'
          curTitle = title
        else
          @subplots[curTitle] = curContent
          curContent = []
      else
        curContent.push line
    @

  _nlCB: ()=>
    @_runNextLine()
    @

  _runPlot: ()->
    @curPlot = @subplots[@DEAFULT_PLOT_TITLE]
    @curLineIdx = -1
    @_runNextLine()
    @

  _runNextLine: ()->
    @curLineIdx++
    curLine = @curPlot[@curLineIdx]
    if curLine is undefined or curLine is null
      console.log "Error: Bad plot detected."
      return
    spaceIdx = curLine.indexOf ' '
    program = curLine.substr(0, spaceIdx)
    rest = curLine.substr(spaceIdx + 1)
    switch program
      when 'speak' then @_handleSpeakCmd rest
      when 'mood' then @_handleMoodCmd rest
      when 'select' then @_handleSelectCmd rest
      when 'avatar' then @_handleAvatarCmd rest
      when 'wait' then @_handleWaitCmd rest
      when 'select' then @_handleSelectCmd rest
      when 'exit' then @_handleExitCmd rest
    @

  _handleMoodCmd: (arg)->
    mood = "MOOD_#{arg}"
    @stage.alterMood(@stage.avatar[mood], @_nlCB)

  _handleSpeakCmd: (arg)->
    @stage.speak(arg, @_nlCB)

  _handleSelectCmd: (arg)->

  _handleAvatarCmd: (arg)->
    @stage.avatarAppear(@_nlCB) if arg is 'fadein'
    @stage.avatarDisappear(@_nlCB) if arg is 'fadeout'

  _handleWaitCmd: (arg) ->
    setTimeout(@_nlCB, parseInt arg)

  _handleSelectCmd: (arg) ->
    matchResults = arg.match(/\((\w+\))([^\(\)]+)/g)
    selections = []
    selectionCbs = []
    for result in matchResults
      selectionResult = result.match(/\((\w+)\)(.+)/)
      selectionCbs.push(selectionResult[1])
      selections.push(selectionResult[2])
    @stage.select(selections,
      (idx) =>
        @curLineIdx = -1
        @curPlot = @subplots[selectionCbs[idx]]
        @_runNextLine()
    )

  _handleExitCmd: (arg)->

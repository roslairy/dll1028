# Plot object.
# Plot will construct a stage and run a plot in it.
class Plot

  # Path to plot file.
  PLOT_PATH: 'dist/microsoft.plot'

  # First section of plot.
  DEAFULT_PLOT_TITLE: 'default'

  # Delay when altered mood.
  ALTER_MOOD_DELAY: 1000

  # Control plot process.
  subplots: {}
  curPlot: null
  curLineIdx: 0

  # Construct a plot.
  constructor: ->
    @stage = new Stage
    @_loadPlot()

  # Keep stage responsive.
  scaleToSize: (width, height) ->
    @stage.scaleToSize(width, height)

  # Legacy.
  update: (time)->

  # Paint the stage with paticular renderer.
  # @param renderer used to render stage.
  paint: (renderer)->
    renderer.render(@stage)

  # Load plot file to cache.
  _loadPlot: ()->
    PIXI.loader
      .add('plot', @PLOT_PATH)
      .load(
        (loader, resources) =>
          @_parsePlot(resources)
          @_runPlot()
      );

  # Parse plot in cache.
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

  # Callback used to continue plot.
  _nlCB: ()=>
    @_runNextLine()
    @

  # Begin to run plot.
  _runPlot: ()->
    @curPlot = @subplots[@DEAFULT_PLOT_TITLE]
    @curLineIdx = -1
    @_runNextLine()
    @

  # Parese on line in current subplot and run it.
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

  # Handle "mood" command
  _handleMoodCmd: (arg)->
    mood = "MOOD_#{arg}"
    @stage.alterMood(@stage.avatar[mood], @_nlCB)

  # Handle "speak" command
  _handleSpeakCmd: (arg)->
    @stage.speak(arg, @_nlCB)

  # Handle "avatar" command
  _handleAvatarCmd: (arg)->
    @stage.avatarAppear(@_nlCB) if arg is 'fadein'
    @stage.avatarDisappear(@_nlCB) if arg is 'fadeout'

  # Handle "wait" command
  _handleWaitCmd: (arg) ->
    setTimeout(@_nlCB, parseInt arg)

  # Handle "select" command
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

  # Handle "exit" command
  _handleExitCmd: (arg)->
    # Do nothing to stop plot.

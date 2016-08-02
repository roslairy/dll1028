Game =

  # Entrance for entire game.
  run: ->
    @createCanvas()
    @createPlot()
    @scaleToWindowSize()
    requestAnimationFrame((time)=> @mainLoop.call(@, time))
    @

  # Create a canvas on the center of window
  createCanvas: ->
    @renderer = PIXI.autoDetectRenderer(800, 600, {transparent : true, antialias: true})
    document.body.appendChild @renderer.view
    window.addEventListener(
      "resize",
      () =>
        @scaleToWindowSize()
    )
    @

  # Keep canvas responsive to window size
  scaleToWindowSize: ->
    @height = window.innerHeight - 8
    @width = @height * 10 / 16
    margin_left = (window.innerWidth - @width) / 2
    @renderer.resize(@width, @height);
    @renderer.view.setAttribute('style', "margin-left: #{margin_left}px");
    @plot.scaleToSize(@width, @height)
    @

  createPlot: ->
    @plot = new Plot
    @

  mainLoop: (time)->
    TWEEN.update(time)
    @plot.update(time)
    @plot.paint(@renderer)
    requestAnimationFrame((time)=> @mainLoop.call(@, time))
    @

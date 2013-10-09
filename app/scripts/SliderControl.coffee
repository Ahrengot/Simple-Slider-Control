hasAMD = ( typeof define is "function" and define.amd )

wrap = ($) ->
	class SliderControl
		constructor: (@el, opts, value = 0) ->
			@cacheElements()
			
			@opts = $.extend( @getDefaultOptions(), opts )
			@init()
			
			@onDragCb = opts?.onDrag
			@onDragEndCb = opts?.onDragEnd

			$(window).on( "resize", @handleResize )
			@handleResize()
			
			@setValue value
		cacheElements: ->
			@track = @el.querySelector ".track"
			@handle = @el.querySelector ".handle"
		getDefaultOptions: ->
			type: "x"
			zIndexBoost: no
			bounds: @getBounds()
			onDrag: @handleDrag
			onDragScope: @
			onDragEnd: @handleDragEnd
			onDragEndScope: @
		init: ->
			@draggable = new Draggable( @handle, @opts )
		getSlideValue: ->
			if @opts.steps
				closest = @getClosestStep @draggable.x
				@draggable.x = closest
				@setValue closest
				@draggable.render()
			 
			return @draggable.x / ( @draggable.vars.bounds.width - @getHandleWidth() )
		getBounds: ->
			handleW = @getHandleWidth()
			bounds = @track.getBoundingClientRect()
				
			left = bounds.left - handleW / 2
			right = bounds.right
			width = bounds.width + handleW

			{ left, right, width }
		getClosestStep: (value) ->
			steps = @draggable.vars.snap
			console.log steps

			console.warn "Apply steps selv. Måske TweenLite???"

			return 135
		getSnapPoints: ->
			width = @track.getBoundingClientRect().width
			distBetweenPoints = width / @opts.steps
			snapPoints = ( distBetweenPoints * i for i in [0..@opts.steps] )
			return snapPoints
		getHandleWidth: ->
			parseInt getComputedStyle( @handle ).width
		handleResize: =>
			@draggable.vars.bounds = @getBounds()
			if @opts.steps then @draggable.vars.snap = @getSnapPoints()
			@draggable.update()
		handleDrag: ->
			@value = @getSlideValue()
			if @onDragCb then @onDragCb.apply( @, arguments )
		handleDragEnd: ->
			@value = @getSlideValue()
			if @onDragEndCb then @onDragEndCb.apply( @, arguments )
		setValue: (value) ->
			@value = value
			@handle.style.left = value * 100 + "%"
			@draggable.update()
		disable: ->
			$(window).off()
			@draggable.disable()
		enable: ->
			@draggable.enable()
			$(window).on( "resize", @handleResize )
			@handleResize()
		destroy: ->
			$(window).off()
			

	# Make SliderControl a global object for those that don't use an AMD
	window.SliderControl = SliderControl unless hasAMD

###
# Support both AMD and non-AMD setups
###
if hasAMD 
	deps = [
		"jquery",
		"bower_components/greensock-js/src/uncompressed/utils/Draggable"
		"bower_components/greensock-js/src/uncompressed/plugins/CSSPlugin"
		"bower_components/greensock-js/src/uncompressed/TweenLite"
	]
	define( deps, wrap ) 
else 
	wrap jQuery
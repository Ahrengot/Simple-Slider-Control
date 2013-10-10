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
			
			@setValue( value, value > 0, yes )
		
		cacheElements: ->
			@track = @el.querySelector ".track"
			@handle = @el.querySelector ".handle"
		
		handleResize: =>
			@draggable.vars.bounds = @getBounds()
			if @opts.steps then @draggable.vars.snap = @getSnapPoints()
			@draggable.update()
		
		getDefaultOptions: ->
			type: "x"
			zIndexBoost: no
			bounds: @getBounds()
			onDrag: @handleDrag
			onDragScope: @
			onDragEnd: @handleDragEnd
			onDragEndScope: @
		
		init: -> @draggable = new Draggable( @handle, @opts )

		# Helper methods
		getBounds: ->
			handleW = @handle.clientWidth
			bounds = @track.getBoundingClientRect()
				
			left = bounds.left - handleW / 2
			right = bounds.right
			width = bounds.width + handleW

			{ left, right, width }
		
		getClosestStep: (value) ->
			steps = @draggable.vars.snap
			diffs = ( Math.abs( value - step ) for step in steps )
			minDist = Math.min diffs...

			return steps[i] for val, i in diffs when val is minDist
		getSnapPoints: ->
			width = @track.getBoundingClientRect().width
			distBetweenPoints = width / ( @opts.steps - 1 )
			
			( distBetweenPoints * i for i in [0..@opts.steps] )
		
		convertPercentToPx: (percent) ->
			@track.clientWidth * ( percent / 100 )
		
		convertPxToPercent: (px) ->
			( px / @track.clientWidth ) * 100

		# Drag logic
		handleDrag: ->
			@value = @getSlideValue()
			if @onDragCb then @onDragCb.apply( @, arguments )
		
		handleDragEnd: ->
			@value = @getSlideValue()
			if @onDragEndCb then @onDragEndCb.apply( @, arguments )
		
		getSlideValue: ->
			if @opts.steps
				closest = @getClosestStep @draggable.x
				@setValue( closest, yes, yes )
				return closest
			else 
				@draggable.x / ( @draggable.vars.bounds.width - @handle.clientWidth )

		setValue: (value, updateDraggable = yes, pxValue = no) ->
			if pxValue
				@value = @convertPxToPercent value
			else
				@value = value
				value = @convertPercentToPx value

			TweenLite.set( @handle, { x: value } )

			if updateDraggable then @draggable.update()
		
		# Memory management
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
define ["gsap-draggable"], (Draggable) ->	
	class SliderControl
		constructor: (@el, opts, value = 0) ->
			@cacheElements()
			
			@opts = $.extend( @getDefaultOptions(), opts )
			@init()
			
			@onDragCb = opts?.onDrag
			@onDragEndCb = opts?.onDragEnd

			$(window).on( "resize", @handleResize )
			@handleResize()
			
			@setValue( value, value > 0, no )
		
		cacheElements: ->
			@track = @el.querySelector ".track"
			@handle = @el.querySelector ".handle"
		
		handleResize: =>
			@draggable.vars.bounds = @getBounds()
			if @opts.steps then @draggable.vars.snap = @getSnapPoints()
			
			# Update position of handle
			@setValue @value
		
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
		getTotalHandleWidth: ->
			# Find a way to do this without jQuery
			$(@handle).outerWidth()
		getBounds: ->
			handleW = @getTotalHandleWidth()
			bounds = @track.getBoundingClientRect()

			left = bounds.left - ( handleW / 2 )
			right = bounds.right
			width = bounds.width + handleW + 1 # +1 so we don't run into rounding issues

			{ left, right, width }
		
		getClosestStep: (value) ->
			steps = @draggable.vars.snap
			diffs = ( Math.abs( value - step ) for step in steps )
			minDist = Math.min diffs...

			return steps[i] for val, i in diffs when val is minDist
		getSnapPoints: ->
			width = @track.getBoundingClientRect().width
			distBetweenPoints = width / ( @opts.steps - 1 )

			return ( distBetweenPoints * i for i in [0...@opts.steps] )

		convertFloatToPx: (float) ->
			@track.clientWidth * float
		
		convertPxToFloat: (px) ->
			px / @track.clientWidth

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
				if @opts.throwProps
					return @convertPxToFloat closest
				else
					return @setValue( closest, yes, yes )
			else 
				@draggable.x / ( @draggable.vars.bounds.width - @handle.clientWidth )

		setValue: (value, updateDraggable = yes, pxValue = no) ->
			if pxValue
				@value = @convertPxToFloat value
			else
				@value = value
				value = @convertFloatToPx value

			TweenLite.set( @handle, { x: value } )

			if updateDraggable then @draggable.update()

			return @value
		
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
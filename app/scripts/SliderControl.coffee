hasAMD = ( typeof define is "function" and define.amd )

wrap = ($) ->
	class SliderControl
		constructor: (@el, opts) ->
			defaults = 
				something: "lol"
				somethingElse: "rofl"
			
			@opts = $.extend( opts, defaults )
			
			# If ThrowProps enabled, require throwProps first
			@init()
		init: ->
			console.log "New SliderControl created"

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
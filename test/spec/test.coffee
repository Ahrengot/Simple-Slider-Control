describe "AMD support", ->
	it "Should be AMD compatible and sub-load all requirements"
	it "Should load ThrowProps if physics are enabled via the options object"

describe "Basic functionality", ->
	it "Should have a 'value' property at all times holding the current slider value"
	it "Should initially set handle position if instantiated with a defined value"
	it "Should support fluid movement along the track"
	it "Should support stepped movement along the track"

describe "Memory management and disable/enable functionality", ->
	it "Should remove all event listeners when calling the destroy() method"
	it "Should have a disable method that allows you to temporarily turn off the slider"
	it "Should be able to resume from the disabled state"
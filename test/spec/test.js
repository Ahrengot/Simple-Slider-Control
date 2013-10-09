/*
describe "AMD support", ->
	it "Should be AMD compatible and sub-load all requirements"
	it "Should load ThrowProps if physics are enabled via the options object"

describe "Basic functionality", ->
	it "Should have a 'value' property at all times holding the current slider value"
	it "Should initially set handle position if instantiated with a defined value"
	it "Should support fluid movement along the track"
	it "Should support stepped movement along the track"
*/


(function() {
  describe("Memory management and disable/enable functionality", function() {
    return it("Should remove all event listeners when calling the destroy method", function() {
      return expect(SliderControl).to.respondTo("destroy");
    });
  });

}).call(this);

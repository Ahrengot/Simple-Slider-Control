(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(["gsap-draggable"], function(Draggable) {
    var SliderControl;
    return SliderControl = (function() {
      function SliderControl(el, opts, value) {
        this.el = el;
        if (value == null) {
          value = 0;
        }
        this.handleResize = __bind(this.handleResize, this);
        this.cacheElements();
        this.opts = $.extend(this.getDefaultOptions(), opts);
        this.init();
        this.onDragCb = opts != null ? opts.onDrag : void 0;
        this.onDragEndCb = opts != null ? opts.onDragEnd : void 0;
        $(window).on("resize", this.handleResize);
        this.handleResize();
        this.setValue(value, value > 0, false);
      }

      SliderControl.prototype.cacheElements = function() {
        this.track = this.el.querySelector(".track");
        return this.handle = this.el.querySelector(".handle");
      };

      SliderControl.prototype.handleResize = function() {
        this.draggable.vars.bounds = this.getBounds();
        if (this.opts.steps) {
          this.draggable.vars.snap = this.getSnapPoints();
        }
        return this.setValue(this.value);
      };

      SliderControl.prototype.getDefaultOptions = function() {
        return {
          type: "x",
          zIndexBoost: false,
          bounds: this.getBounds(),
          onDrag: this.handleDrag,
          onDragScope: this,
          onDragEnd: this.handleDragEnd,
          onDragEndScope: this
        };
      };

      SliderControl.prototype.init = function() {
        return this.draggable = new Draggable(this.handle, this.opts);
      };

      SliderControl.prototype.getTotalHandleWidth = function() {
        return $(this.handle).outerWidth();
      };

      SliderControl.prototype.getBounds = function() {
        var bounds, handleW, left, right, width;
        handleW = this.getTotalHandleWidth();
        bounds = this.track.getBoundingClientRect();
        left = bounds.left - (handleW / 2);
        right = bounds.right;
        width = bounds.width + handleW + 1;
        return {
          left: left,
          right: right,
          width: width
        };
      };

      SliderControl.prototype.getClosestStep = function(value) {
        var diffs, i, minDist, step, steps, val, _i, _len;
        steps = this.draggable.vars.snap;
        diffs = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = steps.length; _i < _len; _i++) {
            step = steps[_i];
            _results.push(Math.abs(value - step));
          }
          return _results;
        })();
        minDist = Math.min.apply(Math, diffs);
        for (i = _i = 0, _len = diffs.length; _i < _len; i = ++_i) {
          val = diffs[i];
          if (val === minDist) {
            return steps[i];
          }
        }
      };

      SliderControl.prototype.getSnapPoints = function() {
        var distBetweenPoints, i, width;
        width = this.track.getBoundingClientRect().width;
        distBetweenPoints = width / (this.opts.steps - 1);
        return (function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = this.opts.steps; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push(distBetweenPoints * i);
          }
          return _results;
        }).call(this);
      };

      SliderControl.prototype.convertFloatToPx = function(float) {
        return this.track.clientWidth * float;
      };

      SliderControl.prototype.convertPxToFloat = function(px) {
        return px / this.track.clientWidth;
      };

      SliderControl.prototype.handleDrag = function() {
        this.value = this.getSlideValue();
        if (this.onDragCb) {
          return this.onDragCb.apply(this, arguments);
        }
      };

      SliderControl.prototype.handleDragEnd = function() {
        this.value = this.getSlideValue();
        if (this.onDragEndCb) {
          return this.onDragEndCb.apply(this, arguments);
        }
      };

      SliderControl.prototype.getSlideValue = function() {
        var closest;
        if (this.opts.steps) {
          closest = this.getClosestStep(this.draggable.x);
          if (this.opts.throwProps) {
            return this.convertPxToFloat(closest);
          } else {
            return this.setValue(closest, true, true);
          }
        } else {
          return this.draggable.x / (this.draggable.vars.bounds.width - this.handle.clientWidth);
        }
      };

      SliderControl.prototype.setValue = function(value, updateDraggable, pxValue) {
        if (updateDraggable == null) {
          updateDraggable = true;
        }
        if (pxValue == null) {
          pxValue = false;
        }
        if (pxValue) {
          this.value = this.convertPxToFloat(value);
        } else {
          this.value = value;
          value = this.convertFloatToPx(value);
        }
        TweenLite.set(this.handle, {
          x: value
        });
        if (updateDraggable) {
          this.draggable.update();
        }
        return this.value;
      };

      SliderControl.prototype.disable = function() {
        $(window).off();
        return this.draggable.disable();
      };

      SliderControl.prototype.enable = function() {
        this.draggable.enable();
        $(window).on("resize", this.handleResize);
        return this.handleResize();
      };

      SliderControl.prototype.destroy = function() {
        return $(window).off();
      };

      return SliderControl;

    })();
  });

}).call(this);

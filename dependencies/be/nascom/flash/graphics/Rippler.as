/*
Copyright (c) 2008 NascomASLib Contributors.  See:
    http://code.google.com/p/nascomaslib

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package be.nascom.flash.graphics
{
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.filters.ConvolutionFilter;
    import flash.filters.DisplacementMapFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /** 
     * 
     * The Rippler class creates an effect of rippling water on a source DisplayObject.
     * 
     * @example The following code takes a DisplayObject on the stage and adds a ripple to it, assuming source is a DisplayObject already on the stage.
     * 
     *     <listing version="3.0">
     *         import be.nascom.flash.graphics.Rippler;
     *         
     *         // create a Rippler instance to impact source, with a strength of 60 and a scale of 6.
     *         // The source can be any DisplayObject on the stage, such as a Bitmap or MovieClip object.
     *         var rippler : Rippler = new Rippler(source, 60, 6);
     * 
     *         // create a ripple with size 20 and alpha 1 with origin on position (200, 50)
     *         rippler.drawRipple(100, 50, 20, 1);
     * </listing>
     * 
     * @author David Lenaerts
     * @mail david.lenaerts@nascom.be
     * 
      */
    public class Rippler
    {
        // The DisplayObject which the ripples will affect.
        private var _source : DisplayObject;
        
        // Two buffers on which the ripple displacement image will be created, and swapped.
        // Depending on the scale parameter, this will be smaller than the source
        private var _buffer1 : BitmapData;
        private var _buffer2 : BitmapData;
        
        // The final bitmapdata containing the upscaled ripple image, to match the source DisplayObject
        private var _defData : BitmapData;
        
        // Rectangle and Point objects created once and reused for performance
        private var _fullRect : Rectangle; 			// A buffer-sized Rectangle used to apply filters to the buffer
        private var _drawRect : Rectangle;			// A Rectangle used when drawing a ripple
        private var _origin : Point = new Point();	// A Point object to (0, 0) used for the DisplacementMapFilter as well as for filters on the buffer
        
        // The DisplacementMapFilter applied to the source DisplayObject
        private var _filter : DisplacementMapFilter;
        // A filter causing the ripples to grow
        private var _expandFilter : ConvolutionFilter;
        
        // Creates a colour offset to 0x7f7f7f so there is no image offset due to the DisplacementMapFilter
        private var _colourTransform : ColorTransform;
        
        // Used to scale up the buffer to the final source DisplayObject's scale
        private var _matrix : Matrix;
        
        // We only need 1/scale, so we keep it here
        private var _scaleInv : Number;
		public var strengthdmF:Number=0;
        public var pp:Point=new Point();
        /**
         * Creates a Rippler instance.
         * 
         * @param source The DisplayObject which the ripples will affect.
         * @param strength The strength of the ripple displacements.
         * @param scale The size of the ripples. In reality, the scale defines the size of the ripple displacement map (map.width = source.width/scale). Higher values are therefor also potentially faster.
         * 
         */
        public function Rippler(source : DisplayObject, strength : Number, scale : Number = 2)
        {
            var correctedScaleX : Number;
            var correctedScaleY : Number;
            var dd=50; //mine
            _source = source;
            _scaleInv = 1/scale;
            
            // create the (downscaled) buffers and final (upscaled) image data, sizes depend on scale
            _buffer1 = new BitmapData((source.width+dd)*_scaleInv, (source.height+dd)*_scaleInv, false, 0x000000);
            _buffer2 = new BitmapData(_buffer1.width, _buffer1.height, false, 0x000000);
            _defData = new BitmapData(source.width+dd, source.height+dd, false, 0x7f7f7f);
            
            // Recalculate scale between the buffers and the final upscaled image to prevent roundoff errors.
            correctedScaleX = _defData.width/_buffer1.width;
            correctedScaleY = _defData.height/_buffer1.height;
            
            // Create reusable objects
            _fullRect = new Rectangle(0, 0, _buffer1.width, _buffer1.height);
            _drawRect = new Rectangle();
            
			this.strengthdmF=strength;
            // Create the DisplacementMapFilter and assign it to the source
            _filter = new DisplacementMapFilter(_defData, _origin, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE, strength, strength, "clamp");//"wrap"
			_source.filters = [_filter];
            
            // Create a frame-based loop to update the ripples
            _source.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
            
            // Create the filter that causes the ripples to grow.
            // Depending on the colour of its neighbours, the pixel will be turned white
            //_expandFilter = new ConvolutionFilter(3, 3, [0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5], 3);
            _expandFilter = new ConvolutionFilter(3, 3, [0.5, 1, 0.5, 1, 0, 1, 0.5, 1, 0.5], 3);
            
            // Create the colour transformation based on 
            _colourTransform = new ColorTransform(1, 1, 1, 1, 128, 128, 128);
            
            // Create the Matrix object
            _matrix = new Matrix(correctedScaleX, 0, 0, correctedScaleY);
            
        }

        /**
         * Initiates a ripple at a position of the source DisplayObject.
         * 
         * @param x The horizontal coordinate of the ripple origin.
         * @param y The vertical coordinate of the ripple origin.
         * @param size The size of the ripple diameter on first impact.
         * @param alpha The alpha value of the ripple on first impact.
         */
        public function drawRipple(x : int, y : int, size : int, alpha : Number) : void
        {
        	var half : int = size >> 1;		// We need half the size of the ripple
            var intensity : int = (alpha*0xff & 0xff)*alpha;	// The colour which will be drawn in the currently active buffer
            
            // calculate and draw the rectangle, having (x, y) in its centre
            _drawRect.x = (-half+x)*_scaleInv;	
            _drawRect.y = (-half+y)*_scaleInv;
            _drawRect.width = _drawRect.height = size*_scaleInv;
            _buffer1.fillRect(_drawRect, intensity);
        }
        
       	/**
       	 * Returns the actual ripple image.
       	 */
        public function getRippleImage() : BitmapData
        {
        	return _defData;
        }
        
        /**
         * Removes all memory occupied by this instance. This method must be called before discarding an instance.
         */
        public function destroy() : void
        {
            _source.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
            _buffer1.dispose();
            _buffer2.dispose();
            _defData.dispose();
        }
        
        // the actual loop where the ripples are animated
        private function handleEnterFrame(event : Event) : void
        {
        	// a temporary clone of buffer 2
            var temp : BitmapData = _buffer2.clone();
            // buffer2 will contain an expanded version of buffer1
            _buffer2.applyFilter(_buffer1, _fullRect, _origin, _expandFilter);
            // by substracting buffer2's old image, buffer2 will now be a ring
            _buffer2.draw(temp, null, null, BlendMode.SUBTRACT, null, false);
            // scale up and draw to the final displacement map, and apply it to the filter
            _defData.draw(_buffer2, _matrix, _colourTransform, null, null, true);
            _filter.mapBitmap = _defData;
            _filter.mapPoint = pp;
			_filter.scaleX=this.strengthdmF;
			_filter.scaleY=this.strengthdmF;
			_source.filters = [_filter];
            temp.dispose();
            // switch buffers 1 and 2
            switchBuffers();
        }
        
        // switch buffer 1 and 2, so that 
        private function switchBuffers() : void
        {
            var temp : BitmapData;
            temp = _buffer1;
            _buffer1 = _buffer2;
            _buffer2 = temp;
        }
    }
}
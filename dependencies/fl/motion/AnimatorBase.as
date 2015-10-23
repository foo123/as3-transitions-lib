// Copyright � 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.motion
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.display.SimpleButton;
import flash.utils.Dictionary;

[DefaultProperty("motion")]

/**
 *  Dispatched when the motion finishes playing,
 *  either when it reaches the end, or when the motion is 
 *  interrupted by a call to the <code>stop()</code> or <code>end()</code> methods.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_END
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0
 */
[Event(name="motionEnd", type="fl.motion.MotionEvent")]

/**
 *  Dispatched when the motion starts playing.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_START
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0 
 */
[Event(name="motionStart", type="fl.motion.MotionEvent")]

/**
 *  Dispatched when the motion has changed and the screen has been updated.
 *
 *  @eventType fl.motion.MotionEvent.MOTION_UPDATE
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0 
 */
[Event(name="motionUpdate", type="fl.motion.MotionEvent")]

/**
 *  Dispatched when the Animator's <code>time</code> value has changed, 
 *  but the screen has not yet been updated (i.e., the <code>motionUpdate</code> event).
 * 
 *  @eventType fl.motion.MotionEvent.TIME_CHANGE
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0 
 */
[Event(name="timeChange", type="fl.motion.MotionEvent")]






/**
 * The AnimatorBase class applies an XML description of a motion tween to a display object.
 * The properties and methods of the AnimatorBase class control the playback of the motion,
 * and Flash Player broadcasts events in response to changes in the motion's status.
 * The AnimatorBase class is primarily used by the Copy Motion as ActionScript command in Flash CS4.
 * You can then edit the ActionScript using the application programming interface
 * (API) or construct your own custom animation. 
 * The AnimatorBase class should not be used on its own. Use its subclasses: Animator or Animator3D, instead.
 *
 * <p>If you plan to call methods of the AnimatorBase class within a function, declare the AnimatorBase 
 * instance outside of the function so the scope of the object is not restricted to the 
 * function itself. If you declare the instance within a function, Flash Player deletes the 
 * AnimatorBase instance at the end of the function as part of Flash Player's routine "garbage collection"
 * and the target object will not animate.</p>
 * 
 * @internal <p><strong>Note:</strong> If you're not using Flash CS4 to compile your SWF file, you need the
 * fl.motion classes in your classpath at compile time to apply the motion to the display object.</p>
 *
 * @playerversion Flash 9.0.28.0
 * @langversion 3.0
 * @keyword Animator, Copy Motion as ActionScript
 * @see ../../motionXSD.html Motion XML Elements
 */
public class AnimatorBase extends EventDispatcher
{	
    /**
     * @private
     */
	private var _motion:MotionBase;

    /**
     * The object that contains the motion tween properties for the animation. 
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword motion     
     */
    public function get motion():MotionBase
    {
        return this._motion;
    }

    /**
     * @private (setter)
     */
	public function set motion(value:MotionBase):void
	{
		this._motion = value;
	}

    /**
     * Sets the position of the display object along the motion path. If set to <code>true</code>
     * the baseline of the display object orients to the motion path; otherwise the registration
     * point orients to the motion path.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword orientToPath, orientation
     */
	public var orientToPath:Boolean = false;



    /**
     * The point of reference for rotating or scaling a display object. For 2D motion, the transformation point is 
     * relative to the display object's bounding box. The point's coordinates must be scaled to a 1px x 1px box, where (1, 1) is the object's lower-right corner, 
     * and (0, 0) is the object's upper-left corner. For 3Dmotion (when the AnimatorBase instance is an Animator3D), the transformationPoint's x and y plus the transformationPointZ are
     * absolute values in the target parent's coordinate space.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword transformationPoint
     */
    public var transformationPoint:Point;
    public var transformationPointZ:int;

    /**
     * Sets the animation to restart after it finishes.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword autoRewind, loop
     */
    public var autoRewind:Boolean = false;



    /**
     * The Matrix object that applies an overall transformation to the motion path. 
     * This matrix allows the path to be shifted, scaled, skewed or rotated, 
     * without changing the appearance of the display object.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword positionMatrix     
     */
	public var positionMatrix:Matrix;
	
	
	


    /**
     *  Number of times to repeat the animation.
     *  Possible values are any integer greater than or equal to <code>0</code>.
     *  A value of <code>1</code> means to play the animation once.
     *  A value of <code>0</code> means to play the animation indefinitely
     *  until explicitly stopped (by a call to the <code>end()</code> method, for example).
     *
     * @default 1
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword repeatCount, repetition, loop   
     * @see #end()
     */
	public var repeatCount:int = 1;

	
	/**
     * @private
     */
    private var _isPlaying:Boolean = false;

    /**
     * Indicates whether the animation is currently playing.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword isPlaying        
     */
	public function get isPlaying():Boolean
	{
		return _isPlaying;
	}


    /**
     * @private
     */
	protected var _target:DisplayObject;

    /**
     * The display object being animated. 
     * Any subclass of flash.display.DisplayObject can be used, such as a <code>MovieClip</code>, <code>Sprite</code>, or <code>Bitmap</code>.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword target
     * @see flash.display.DisplayObject
     */
    public function get target():DisplayObject
    {
        return this._target;
    }

    /**
     * @private (setter)
     */
	public function set target(value:DisplayObject):void 
	{
		if (!value) return;
		this._target = value;
		
		var setTargetStateOriginal:Boolean = false;
		if(this.targetParent && this.targetName != "")
		{
			if(this.targetStateOriginal) 
			{
				this.targetState = this.targetStateOriginal;
				return;
			}
			else
			{
				setTargetStateOriginal = true;
			}
		}

		this.targetState = {};
		this.setTargetState();
		
		if(setTargetStateOriginal)
		{
			this.targetStateOriginal = this.targetState;
		}
	}

     /**
     * @private
     */
	protected function setTargetState():void
	{
	}
	
	public function set initialPosition(initPos:Array):void
	{
		// subclasses can override
	}

	/**
     * @private
     */
	private var _lastRenderedTime:int = -1; 

	 
	/**
     * @private
     */
	private var _time:int = -1; 

    /**
     * A zero-based integer that indicates and controls the time in the current animation. 
     * At the animation's first frame the <code>time</code> value is <code>0</code>. 
     * If the animation has a duration of 10 frames, at the last frame the <code>time</code> value is <code>9</code>. 
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword time
     */
	public function get time():int
	{
		return this._time;
	}

    /**
     * @private (setter)
     */
	public function set time(newTime:int):void 
	{
		if (newTime == this._time) return;
		
		var thisMotion:MotionBase = this.motion;
		
		if (newTime > thisMotion.duration-1) 
			newTime = thisMotion.duration-1;
		else if (newTime < 0) 
			newTime = 0;
			
		this._time = newTime;
		this.dispatchEvent(new MotionEvent(MotionEvent.TIME_CHANGE));
		
		var curKeyframe:KeyframeBase = thisMotion.getCurrentKeyframe(newTime);
		// optimization to detect when a keyframe is "holding" for several frames and not tweening
		var isHoldKeyframe:Boolean = curKeyframe.index == this._lastRenderedTime
									 && !curKeyframe.tweensLength; 
		if (isHoldKeyframe)
			return;
			
		this._target.visible = false;
		
		if (!curKeyframe.blank)
		{
			if(this._isAnimator3D)
			{
				setTime3D(newTime, thisMotion);
			}
			else
			{
				setTimeClassic(newTime, thisMotion, curKeyframe);
			}
			
			var colorTransform:ColorTransform = thisMotion.getColorTransform(newTime);
			if (colorTransform)
			{
				this._target.transform.colorTransform = colorTransform;
			}
	
			var filters:Array = thisMotion.getFilters(newTime); 
			if(filters)
			{
				this._target.filters = filters;
			}
			
			this._target.blendMode = curKeyframe.blendMode;
			this._target.visible = true;
		}
		
		this._lastRenderedTime = this._time;
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_UPDATE));
	}
	
     /**
     * @private
     */
	protected function setTime3D(newTime:int, thisMotion:MotionBase):Boolean
	{
		return false;
	}


     /**
     * @private
     */
	protected function setTimeClassic(newTime:int, thisMotion:MotionBase, curKeyframe:KeyframeBase):Boolean
	{
		return false;
	}
	
	private var _targetParent:DisplayObjectContainer = null;
	private var _targetName:String = "";
	private var targetStateOriginal:Object = null;
	

    /**
     * The target parent <code>DisplayObjectContainer</code> being animated, which can be used in conjunction with <code>targetName</code>
     * to retrieve the target object after it is removed and then replaced on the timeline.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0       
     */
	public function get targetParent():DisplayObjectContainer {
		return _targetParent;
	}
	public function set targetParent(p:DisplayObjectContainer):void {
		_targetParent = p;
	}
	
	
	
    /**
     * The name of the target object as seen by the parent <code>DisplayObjectContainer</code>.
     * This can be used in conjunction with <code>targetParent</code> to retrieve the target object after it is removed and then replaced on the timeline.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0       
     */
	public function get targetName():String {
		return _targetName;
	}
	public function set targetName(n:String):void {
		_targetName = n;
	}
	
	
	
	private var _useCurrentFrame:Boolean = false;
	
	/**
     * Sets the <code>currentFrame</code> property whenever a new frame is entered, and
     * sets whether the target's animation is synchronized to the frames in its parent MovieClips's timeline.
     * <code>spanStart</code> is the start frame of the animation in terms of the parent's timeline. 
     * If <code>enable</code> is <code>true</code>, then in any given enter frame event within the span of the animation, 
     * the <code>time</code> property is set to a frame number relative to the <code>spanStart</code> frame.
     *
     * <p>For example, if a 4-frame animation starts on frame 5 (<code>spanStart=5</code>), 
     * and you have a script on frame 5 to <code>gotoAndPlay</code> frame 8,
     * then upon entering frame 8 the time property is set to <code>3</code> (skipping <code>time = 1</code>
     * and <code>time = 2</code>).</p>
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @param enable The true or false value that determines whether the currentFrame property is checked.
     * @param spanStart The start frame of the animation in terms of the parent MovieClip's timeline.
     */
	public function useCurrentFrame(enable:Boolean, spanStart:int):void
	{
		_useCurrentFrame = enable;
		_spanStart = spanStart;
	}
	
   /**
	* Indicates whether the <code>currentFrame</code> property is checked whenever a new frame is entered and
	* whether the target's animation is synchronized to the frames in its parent's timeline, 
	* or always advancing no matter what the parent's current frame is.
	* @playerversion Flash 9.0.28.0
	* @langversion 3.0       
    */
	public function get usingCurrentFrame():Boolean
	{
		return _useCurrentFrame;
	}
	
	private var _spanStart:int = -1;
	
   /**
	* Returns the frame of the target's parent on which the animation of the target begins.
	* @playerversion Flash 9.0.28.0
	* @langversion 3.0       
    */
	public function get spanStart():int
	{
		return _spanStart;
	}
	
   /**
	* Returns the frame of the target's parent on which the animation of the target ends. 
	* This value is determined using <code>spanStart</code> and the motion's <code>duration</code> property.
	* @playerversion Flash 9.0.28.0
	* @langversion 3.0       
   	*/
	public function get spanEnd():int
	{
		if(this._motion && this._motion.duration > 0) {
			return _spanStart + this._motion.duration - 1;
		}
		
		return _spanStart;
	}
	
	// for animations that we actually export (for 3d), we have
	// to track the scenes that contain them in order to determine
	// whether or not they should play - the parent timeline's frame
	// number is not enough
	private var _sceneName:String = "";
	
	public function set sceneName(name:String):void
	{
		this._sceneName = name;
	}
	
	public function get sceneName():String
	{
		return this._sceneName;
	}
	
	private static var _registeredParents:Dictionary = new Dictionary(true);
	
   /**
	* Registers the given <code>MovieClip</code> and an <code>AnimatorBase</code> instance for a child of that <code>MovieClip</code>.
	* The parent MovieClip's <code>FRAME_CONSTRUCTED</code> events are processed,
	* and its <code>currentFrame</code> and the AnimatorBase's <code>spanStart</code> properties 
	* are used to determine the current relative frame of the animation that should be playing. 
	* <p>Calling this function automatically sets the AnimatorBase's <code>useCurrentFrame</code> property to <code>true</code>,
	* and its <code>spanStart</code> property using the parameter of the same name.</p>
	* @playerversion Flash 9.0.28.0
	* @langversion 3.0
        * @param parent The parent MovieClip of the AnimatorBase instance.
        * @param anim The AnimatorBase instance associated with the parent MovieClip.
        * @param spanStart The start frame of the animation in terms of the parent MovieClip's timeline.
        * @param repeatCount The number of times the animation should play. The default value is 0, which means the animation will loop indefinitely.
        * @param useCurrentFrame Indicates whether the useCurrentFrame property is checked whenever a new frame is entered.
   */
	public static function registerParentFrameHandler(parent:MovieClip, anim:AnimatorBase, spanStart:int, repeatCount:int = 0, useCurrentFrame:Boolean = false):void
	{
		var animParent:AnimatorParent = _registeredParents[parent] as AnimatorParent;
		if(animParent == null)
		{	
			animParent = new AnimatorParent();
			animParent.parent = parent;
			_registeredParents[parent] = animParent;
		}
		
		if(spanStart == -1) {
			spanStart = parent.currentFrame - 1;
		}
		
		if(useCurrentFrame)
		{	
			anim.useCurrentFrame(true, spanStart);
		}
		else
		{
			// if we're not trying to adhere to the parent's timeline,
			// then we'll just keep looping the animation by default
			anim.repeatCount = repeatCount;
		}
		
		animParent.animators.push(anim);
	}
	
	private static function parentEnterFrameHandler(evt:Event):void
	{
		for(var parentObj:* in _registeredParents)
		{
			var animParent:AnimatorParent = _registeredParents[parentObj] as AnimatorParent;
			if(!animParent) {
				continue;
			}
			
			var parent:MovieClip = animParent.parent;
			var parentAnims:Array = animParent.animators;
			if(!parent || !parentAnims) {
				continue;
			}
				
			for(var i:int = 0; i < parentAnims.length; i++) {
				var anim:AnimatorBase = parentAnims[i] as AnimatorBase;
				
				// if the current frame of this parent is the same as the last one
				// we processed, and we are in the usingCurrentFrame mode for the 
				// animation, then don't reprocess the frame. this has to be done
				// at the parent level instead of within the animation because there
				// can be multiple Animators for a given child object (but they would
				// never overlap frames).  
				if(!anim.usingCurrentFrame || (parent.currentFrame != animParent.lastFrameHandled))
				{
					processCurrentFrame(parent, anim, false);
				}
			}
			
			animParent.lastFrameHandled = parent.currentFrame;
		}
	}
	
	public static function processCurrentFrame(parent:MovieClip, anim:AnimatorBase, startEnterFrame:Boolean, playOnly:Boolean = false):void
	{
		if(anim && parent) {
			// if the parent got removed from the timeline, then our target
			// is no longer visible anyway, so bail
			if(!parent.root)
			{
				if(anim.usingCurrentFrame && !anim.isPlaying && playOnly)
				{
					anim.startFrameEvents();
				}
				return;
			}
			
			if(anim.usingCurrentFrame)
			{
				// if the animator is not playing but the playhead
				// has jumped to a frame that's part of the animation,
				// then start it up
				var curFrame:int = parent.currentFrame-1;
				
				// check to make sure we're in the right scene for this
				// animation - if there's only one scene then don't bother
				// checking
				if(parent.scenes.length > 1)
				{
					if(parent.currentScene.name != anim.sceneName)
					{
						curFrame = -1; // we're not in the current animation
					}
				}
				
				if(curFrame >= anim.spanStart && 
						curFrame <= anim.spanEnd)
				{
					var curRelativeFrame:int = curFrame-anim.spanStart;
					if(!anim.isPlaying)
					{
						anim.play(curRelativeFrame, startEnterFrame);
					}
					else if(!playOnly)
					{
						if(curFrame == anim.spanEnd)
						{
							anim.handleLastFrame(true, false);
						}
						else
						{
							anim.time = curRelativeFrame;
						}
					}
				}
				
				// otherwise, if it is playing but the playhead
				// has moved out of the span of the animation, then
				// stop it
				else if(anim.isPlaying && !playOnly)
				{
					anim.end(true, false);
				}
				else if(!anim.isPlaying && playOnly)
				{
					anim.startFrameEvents();
				}
			}
			else 
			{
				if(anim.targetParent && 
						anim.targetParent[anim.targetName] == null &&
						anim.targetParent.getChildByName(anim.targetName) == null)
				{
					if(anim.isPlaying)
					{
						anim.end(true, false);
					}
					else if(playOnly)
					{
						anim.startFrameEvents();
					}
				}
				else if(!anim.isPlaying)
				{
					anim.play(0, startEnterFrame);
				}
				else if(!playOnly)
				{
					anim.nextFrame();
				}
			}
		}
	}
	
	private static function get hasRegisteredParents():Boolean
	{
		for(var parent:* in _registeredParents)
		{
			return true;
		}
		return false;
	}
	
	private var _frameEvent:String = Event.ENTER_FRAME; // default to using ENTER_FRAME, but can also used FRAME_CONSTRUCTED
	
	public function get frameEvent():String { return _frameEvent; }
	public function set frameEvent(evt:String):void { _frameEvent = evt; }
	
	private var _targetState3D:Array = null;
	
    /**
     * The initial orientation for the target object. All 3D rotation is absolute to the motion data.
     * If you target another object that has a different starting 3D orientation, it is reset to this target state first.
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @langversion 3.0       
     */
	public function get targetState3D():Array { return _targetState3D; }
	public function set targetState3D(state:Array):void { _targetState3D = state; }
	
    /**
     * @private
     */
	protected var _isAnimator3D:Boolean;
	
	public static function registerButtonState(targetParentBtn:SimpleButton, anim:AnimatorBase, stateFrame:int):void
	{
		var target:DisplayObject = targetParentBtn.upState;
		switch(stateFrame)
		{
			case 1:
			{
				target = targetParentBtn.overState;
				break;
			}
			case 2:
			{
				target = targetParentBtn.downState;
				break;
			}
			case 3:
			{
				target = targetParentBtn.hitTestState;
				break;
			}
		}
		
		if(!target) return;
	
		anim.target = target;
		anim.time = 0;
	}
	
    /**
     * Creates an AnimatorBase object to apply the XML-based motion tween description to a display object.
     * If XML is null (which is the default value), then you can either supply XML directly to a Motion instance 
     * or you can set the arrays of property values in the Motion instance.
     * @param xml An E4X object containing an XML-based motion tween description.
     *
     * @param target The display object using the motion tween.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword AnimatorBase
     * @see ../../motionXSD.html Motion XML Elements
     */
	function AnimatorBase(xml:XML=null, target:DisplayObject=null)
	{
		this.target = target;
		this._isAnimator3D = false;
		this.transformationPoint = new Point(.5, .5);
		this.transformationPointZ = 0;
		this._sceneName = "";
	}

    /**
     * Advances Flash Player to the next frame in the animation sequence.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword nextFrame     
     */
	public function nextFrame():void 
	{
		if (this.time >= this.motion.duration-1)
			this.handleLastFrame();
		else 
			this.time++;
	}




    /**
     *  Begins the animation. Call the <code>end()</code> method 
     *  before you call the <code>play()</code> method to ensure that any previous 
     *  instance of the animation has ended before you start a new one.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @param startTime Indicates an alternate start time (relative frame) to use. If not specified, then the default start time of 0 is used.
     * @param startEnterFrame Indicates whether the event listener needs to be added to the parent in order to capture frame events. 
     * The value can be <code>false</code> if the parent was registered to its AnimatorBase instance via <code>registerParentFrameHandler()</code>.
     * @keyword play, begin
     * @see #end()
     */
	public function play(startTime:int = -1, startEnterFrame:Boolean = true):void
	{
		if (!this._isPlaying)
		{
			if(this._target == null && this._targetParent && this._targetName != "") {
				this.target = this._targetParent[this._targetName];
				
				if(!this.target)
				{
					this.target = this._targetParent.getChildByName(this._targetName);
				}
			}
			
			if(startEnterFrame)
			{
				enterFrameBeacon.addEventListener(frameEvent, this.enterFrameHandler, false, 0, true);
			}
			
			// if we still don't have a target object, get out of here - the
			// parent's enter frame handler will call play again when the target 
			// should exist
			if(!this.target)
			{
				return;
			}
			
			this._isPlaying = true;
		}
		this.playCount = 0;
		// enterFrame event will fire on the following frame, 
		// so call the time setter to update the position immediately
		if(startTime > -1) {
			this.time = startTime;
		}
		else {
			this.rewind();
		}
		
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_START));
	
	}


    /**
     *  Stops the animation and Flash Player goes immediately to the last frame in the animation sequence. 
     *  If the <code>autoRewind</code> property is set to <code>true</code>, Flash Player goes to the first
     * frame in the animation sequence. 
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @param reset Indicates whether <code>_lastRenderedTime</code> and <code>_target</code> should be reset to their original values. 
     * <code>_target</code> only resets if <code>targetParent</code> and <code>targetName</code> have been supplied.
     * @keyword end, stop
     * @see #autoRewind     
     */
	public function end(reset:Boolean = false, stopEnterFrame:Boolean = true):void
	{
		if(stopEnterFrame)
		{
			enterFrameBeacon.removeEventListener(frameEvent, this.enterFrameHandler);
		}
		this._isPlaying = false;
		this.playCount = 0;
		
		if (this.autoRewind) 
			this.rewind();
		else if (this.time != this.motion.duration-1)
			this.time = this.motion.duration-1;
			
		if(reset) {
			if(this._targetParent && this._targetName != "") {
				this._target = null;
			}
			this._lastRenderedTime = -1;
			this._time = -1;
		}
			
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
    }



    /**
     *  Stops the animation and Flash Player goes back to the first frame in the animation sequence.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword stop, end
     * @see #end()      
     */
	public function stop():void
	{
		enterFrameBeacon.removeEventListener(frameEvent, this.enterFrameHandler);
		this._isPlaying = false;
		this.playCount = 0;
		this.rewind();
		this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
    }


    /**
     *  Pauses the animation until you call the <code>resume()</code> method.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword pause
     * @see #resume()        
     */
	public function pause():void
	{
		enterFrameBeacon.removeEventListener(frameEvent, this.enterFrameHandler);
		this._isPlaying = false;
    }



    /**
     *  Resumes the animation after it has been paused 
     *  by the <code>pause()</code> method.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword resume
     * @see #pause()       
     */
	public function resume():void
	{
		enterFrameBeacon.addEventListener(frameEvent, this.enterFrameHandler, false, 0, true);
		this._isPlaying = true;
    }
    
    public function startFrameEvents():void
    {
		enterFrameBeacon.addEventListener(frameEvent, this.enterFrameHandler, false, 0, true);
    }

    /**
     * Sets Flash Player to the first frame of the animation. 
     * If the animation was playing, it continues playing from the first frame. 
     * If the animation was stopped, it remains stopped at the first frame.
     * @playerversion Flash 9.0.28.0
     * @langversion 3.0
     * @keyword rewind
     */
	public function rewind():void
	{
		this.time = 0;
    }
   
   
 //////////////////////////////////////////////////////////////  

	/**
     * @private
     */
    private var playCount:int = 0;


    /**
     * @private
     */
	// This code is run just once, during the class initialization.
	// Create a MovieClip to generate enterFrame events.
 	private static var enterFrameBeacon:MovieClip = new MovieClip();
 


    /**
     * @private
     */
    // The initial state of the target when assigned to the Animator. 
	protected var targetState:Object;
  
  
    /**
     * @private
     */
	private function handleLastFrame(reset:Boolean = false, stopEnterFrame:Boolean = true):void 
	{
		++this.playCount;
		if (this.repeatCount == 0 || this.playCount < this.repeatCount)
		{
			this.rewind();
		}
		else
		{
			this.end(reset, stopEnterFrame);
		}
	}



    /**
     * @private
     */
	private function handleEnterFrame(event:Event):void 
	{
		this.nextFrame();
	}


	private function get enterFrameHandler():Function
	{
		if(AnimatorBase.hasRegisteredParents)
		{
			return AnimatorBase.parentEnterFrameHandler;
		}
		else {
			return handleEnterFrame;
		}
	}
}
}

import flash.display.MovieClip;

class AnimatorParent
{
	public var parent:MovieClip = null;
	public var animators:Array = new Array;
	public var lastFrameHandled:int = -1;
}

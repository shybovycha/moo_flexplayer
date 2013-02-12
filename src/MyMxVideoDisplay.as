package
{
	import mx.controls.VideoDisplay;
	import mx.managers.IFocusManagerComponent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;
	import mx.controls.Alert;
	import mx.events.VideoEvent;
	
	public class MyMxVideoDisplay extends VideoDisplay implements IFocusManagerComponent
	{
		private var oldWidth:int, oldHeight:int;
		private var oldVolume:int;
		
		public function MyMxVideoDisplay()
		{
			super();
			
			this.doubleClickEnabled = true;
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, this.myMouseWheelHandler);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.myMouseDoubleClickHandler);
			this.addEventListener(KeyboardEvent.KEY_UP, this.myKeyUpHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN, this.myKeyDownHandler);
			this.addEventListener(VideoEvent.READY, this.myReadyHandler);
		}
		
		private function myReadyHandler(evt:VideoEvent):void
		{
			this.oldWidth = this.parent.width;
			this.oldHeight = this.parent.height;
			this.oldVolume = 0;
		}
		
		private function toggleFullScreenMode():void
		{
			try
			{
				if (this.stage.displayState != StageDisplayState.FULL_SCREEN)
				{
					this.stage.displayState = StageDisplayState.FULL_SCREEN;
					
					this.oldWidth = this.parent.width;
					this.oldHeight = this.parent.height;
					
					this.parent.width = this.stage.fullScreenWidth;
					this.parent.height = this.stage.fullScreenHeight;
				} else
				{
					this.stage.displayState = StageDisplayState.NORMAL;
					
					this.parent.width = this.oldWidth;
					this.parent.height = this.oldHeight;
					
					this.oldWidth = this.stage.fullScreenWidth;
					this.oldHeight = this.stage.fullScreenHeight;
				}
			} catch (exception:*)
			{
				trace( exception.toString() );
			}
		}
		
		private function changeVolume(delta:int):void
		{
			this.volume += delta / 100.0;
		}
		
		private function togglePauseMode():void
		{
			if (this.state != VideoEvent.PAUSED)
				this.pause(); else
					this.play();
		}
		
		private function toggleMuteMode():void
		{
			this.volume = this.oldVolume;
			this.oldVolume = this.volume;
		}
		
		private function myKeyUpHandler(evt:KeyboardEvent):void
		{
			// space toggles pause mode
			if (evt.keyCode == 32)
			{
				this.togglePauseMode();
			} else
			if (evt.keyCode == 13)
			{
				this.toggleFullScreenMode();
			}
		}
		
		private function rewindVideo(delta:int):void
		{
			this.playheadTime += delta;
		}
		
		private function myKeyDownHandler(evt:KeyboardEvent):void
		{
			//Alert.show(evt.keyCode.toString());
			
			// escape minimizes and pauses player
			if (evt.keyCode == 27)
			{
				try
				{
					this.stage.displayState = StageDisplayState.NORMAL;
					this.pause();
				} catch (exception:*)
				{
					trace( exception.toString() );
				}
			} else
			// left arrow rewinds video back
			if (evt.keyCode == 37)
			{
				//this.rewindVideo(-5);
				this.playheadTime -= 5;
			} else
			// right arrow rewinds video forward
			if (evt.keyCode == 39)
			{
				//this.rewindVideo(5);
				this.playheadTime += 5;
			} else
			// up arrow increases volume
			if (evt.keyCode == 38)
			{
				this.changeVolume(1);
			} else
			// down arrow decreases volume
			if (evt.keyCode == 40)
			{
				this.changeVolume(-1);
			} else
			// m mutes video
			if (evt.keyCode == 77)
			{
				this.toggleMuteMode();
			}
		}
		
		private function myMouseWheelHandler(evt:MouseEvent):void
		{
			this.changeVolume(evt.delta);
		}
		
		private function myMouseDoubleClickHandler(evt:MouseEvent):void
		{
			this.toggleFullScreenMode();
		}
	}
}
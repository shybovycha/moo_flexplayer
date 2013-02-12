package
{
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import spark.components.VideoDisplay;
	import mx.managers.IFocusManagerComponent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import org.osmf.media.MediaPlayerState;
	import flash.display.StageDisplayState;
	import mx.controls.Alert;
	
	public class MyVideoDisplay extends VideoDisplay implements IFocusManagerComponent
	{
		private var oldWidth:int, oldHeight:int;
		
		public function MyVideoDisplay()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, this.myMouseWheelHandler);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, this.myMouseDoubleClickHandler);
			this.addEventListener(KeyboardEvent.KEY_UP, this.myKeyUpHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN, this.myKeyDownHandler);
			this.addEventListener(MediaPlayerState.READY, this.myReadyHandler);
		}
		
		private function myReadyHandler(evt:MediaPlayerStateChangeEvent):void
		{
			this.oldWidth = this.width;
			this.oldHeight = this.height;
		}
		
		private function toggleFullScreenMode():void
		{
			try
			{
				if (this.stage.displayState != StageDisplayState.FULL_SCREEN)
				{
					this.stage.displayState = StageDisplayState.FULL_SCREEN;
					
					this.oldWidth = this.width;
					this.oldHeight = this.height;
					
					this.width = this.stage.fullScreenWidth;
					this.height = this.stage.fullScreenHeight;
				} else
				{
					this.stage.displayState = StageDisplayState.NORMAL;
					
					this.width = this.oldWidth;
					this.height = this.oldHeight;
					
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
			if (this.mediaPlayerState != MediaPlayerState.PAUSED)
				this.pause(); else
					this.play();
		}
		
		private function toggleMuteMode():void
		{
			this.muted = !this.muted;
		}
		
		private function myKeyUpHandler(evt:KeyboardEvent):void
		{
			// space toggles pause mode
			if (evt.keyCode == 32)
			{
				this.togglePauseMode();
			}
		}
		
		private function rewindVideo(delta:int):void
		{
			this.seek(this.currentTime + delta);
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
				this.seek(this.currentTime - 5);
			} else
			// right arrow rewinds video forward
			if (evt.keyCode == 39)
			{
				//this.rewindVideo(5);
				this.seek(this.currentTime + 5);
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
package APIPlox
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class Logo_Big extends BaseObject
	{
		private var splashScale : Number;
		private var splashStartTime : Number;
		
		private var splash : Boolean;
		
		public function Logo_Big()
		{
			super();
			
			//Make the cursor turn into a hand when hovering over us
			this.mouseEnabled = true;
  			this.buttonMode = true;
			
			//Add a listener for when the logo is clicked
			addEventListener(MouseEvent.MOUSE_UP, logoClick);
			
			var timer:Timer = new Timer(10, 1);
			timer.addEventListener(TimerEvent.TIMER, init);
			timer.start();
		}
		
		private function init(e:TimerEvent):void
		{
			gotoAndStop(Internationalisation.GetLogoFrame());
		}
		
		public function startSplash() : void
		{
			alpha=0;
			splashStartTime = getTimer();
			splashScale = .45 * (stage.stageHeight/400);
			splash = true;
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			
			if (splash)
			{
				splashScale += .00025 * gameTime.Delta;
				if (GameTime.MilisecondsPassed-splashStartTime < 2000)
				{
					if (alpha<1)
						alpha += .01 * gameTime.Delta;
				}
				if (GameTime.MilisecondsPassed-splashStartTime > 7650)
				{
					if (alpha>0)
						alpha -= .03 * gameTime.Delta;
				}
				width = 785 * splashScale;
				height = 378 * splashScale;
			}
		}
		
		public function logoClick(e:MouseEvent):void
		{
			PLOX_Achievements.SPLASHTASTIC_MARKETING.Achieve();
			
			var targetURL:URLRequest = new URLRequest(Internationalisation.GetLink());
			navigateToURL(targetURL);
		}
		
	}
}
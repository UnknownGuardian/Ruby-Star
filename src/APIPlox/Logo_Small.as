package APIPlox
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	public class Logo_Small extends BaseObject
	{
		public function Logo_Small()
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
		
		private function init(e:TimerEvent)
		{
			gotoAndStop(Internationalisation.GetLogoFrame());
		}
		
		public override function Update(gameTime:GameTime):void
		{
			//trace("Kleine logo update");
		}
		
		function logoClick(e:MouseEvent)
		{
			var targetURL:URLRequest = new URLRequest(Internationalisation.GetLink());
			navigateToURL(targetURL);
		}
	}
}
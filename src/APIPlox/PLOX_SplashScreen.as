package APIPlox
{
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.utils.Timer;

	public class PLOX_SplashScreen extends BaseObject
	{
		
		private var bigLogo : Logo_Big;
		public var splashTimer : Timer;
		
		private var listener : Function;
		
		public function PLOX_SplashScreen(listener : Function)
		{
			super();
			
			this.listener = listener;
			
			trace("Showing splash screen...");
		}
		
		public override function Activate(e:Event):void
		{
			super.Activate(e);
			
			//Draw background
			DrawBG();
			
			//Play sound
			var snd : Sound = new Plox_Splash();
			snd.play();
			
			//Create the logo for the splash screen
			bigLogo = new Logo_Big();
			bigLogo.x = (stage.stageWidth/2);
			bigLogo.y = (stage.stageHeight/2);
			addChild(bigLogo);
			bigLogo.startSplash();
			
			//Add a timer for the splash screen
			splashTimer = new Timer(8000, 1);//8000
			splashTimer.addEventListener(TimerEvent.TIMER_COMPLETE, splashTimerDone);
			splashTimer.start();
		}
		
		public function splashTimerDone(e:TimerEvent):void{
			listener.call();
			Remove();
		}
		
		private function DrawBG():void
		{
			var linMatrix:Matrix = new Matrix( );
			linMatrix.createGradientBox( stage.stageWidth*2, stage.stageHeight*2, (90 * Math.PI / 180), -stage.stageWidth/(2), -stage.stageHeight*(2/2) );
			
			var w : Number = stage.stageWidth;
			var h : Number = stage.stageHeight;
			var xx : Number = w/2;
			var yy : Number = h/2;
			var X : Number;
			var Y : Number;
			var s : Number = 35 * Math.max(w/550, h/400);
			var d : Number = Math.max(w, h);
			var a : Number = 0;
			
			graphics.clear();
			graphics.beginGradientFill(GradientType.RADIAL, [0xfdd628,0xff2007], [100, 100], [0, 255], linMatrix);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			
			linMatrix = new Matrix( );
			linMatrix.createGradientBox(w,h);
			var stripes : int = 23;
			for (var i : int = 0; i<stripes; i++)
			{
				//trace("IK TEKEN STREEP #"+i);
				a = (360/stripes) * i;
				
				X = xx + lenDirX(d, a);
				Y = yy + lenDirY(d, a);
				
				graphics.beginGradientFill(GradientType.RADIAL, [0xfe6b15,0xfe6b15], [0, 100], [127, 255], linMatrix);
				graphics.moveTo(xx,yy);
				graphics.lineTo(X + lenDirX(s, a-90), Y + lenDirY(s, a-90));
				graphics.lineTo(X + lenDirX(s, a+90), Y + lenDirY(s, a+90));
				graphics.lineTo(xx,yy);
				graphics.endFill();
			}
		}
		
		private function lenDirX(leng : Number, dir : Number):Number
		{
			return Math.sin(dir * Math.PI / 180) * leng;
		}
		private function lenDirY(leng : Number, dir : Number):Number
		{
			return Math.cos(dir * Math.PI / 180) * -leng;
		}
	}
}
package APIPlox
{	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class PLOX_Main extends BaseObject
	{
		private static var main : PLOX_Main;
		
		public function PLOX_Main()
		{
			super();
		}
		
		public static function GetInstance() : PLOX_Main
		{
			if (!main)
				main = new PLOX_Main();
			return main;
		}
		
		//This is called when all the loading is complete
		//Start your game from here
		public override function Activate(e:Event):void
		{
			
			stage.addChild(new Main());
			//PLOX_Highscores.AddScore("Rik", "12");
			//PLOX_Achievements.BOOT_KING.Achieve(false);
			
			//var panel : PLOX_GUIPanel;
			
			//Show high-scores window
			//panel = new PLOX_LeaderboardsPanel(stage.stageWidth/2 - 202, stage.stageHeight/2 - 151, 404,303); addChild(panel);
			
			//Show achievements window
			//panel = new PLOX_AchievementsPanel(stage.stageWidth/2 - 202, stage.stageHeight/2 - 151, 404,303); addChild(panel);
		}
	}
}
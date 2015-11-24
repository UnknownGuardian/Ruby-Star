package APIPlox
{	
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class Program extends BaseObject
	{
		//Sub-systems
		private var loadmanager : PLOX_LoadManager;
		private var i18n : Internationalisation;
		private var highscores : PLOX_Highscores;
		private var achievements : PLOX_Achievements;
		
		//For the download manager
		public var doneLoading : Boolean;
		
		private var logo : Logo_Big;
		private var splashTimer : Timer;
		private var progressImage : ProgressImage;
		private var playButton : PLOX_PlayButton;
		private var play_press : Boolean;
		private var advertisementBar : PLOX_AdvertisementBar;
		
		public function Program():void
		{
			super();
			//Create a new load manager
			loadmanager = new PLOX_LoadManager(this);
			
			
			////////////////////////////////////////////////////////////////////////////////
			//
			// PLOX API v1.0.0
			// by Roy Theunissen (roy.theunissen@live.nl)
			// ----------------------------------------------------------------------------
			// The set-up is below. Choose a unique name for your game.
			// Amongst the most important things are the unique name and the style of the
			// advertisement bar. Those are pretty much the only things you need to edit.
			////////////////////////////////////////////////////////////////////////////////
			
			
			//Create new internationalisation manager
			i18n = new Internationalisation(loadmanager, "Ruby Star");
			
			//Initializing the Advertisement Bar
			advertisementBar = new PLOX_AdvertisementBar();
				//Example of a customized advertisement bar. Make sure the chosen font is imported to the project. You can also specify the name of a MovieClip to use as a background.
				//advertisementBar = new PLOX_AdvertisementBar([0xff0000,0x0000ff], [0xff7777,0x7777ff], new TextFormat("Arial", 18, 0x00ff00, false, true),new TextFormat("Arial", 18, 0x0000ff, false, true), testBackground);
			
			//Initializing Highscore System
			highscores = new PLOX_Highscores();
			
			//Initializing Achievements System
			achievements = PLOX_Achievements.GetInstance(loadmanager);
			
			//Initializing Persistent Variables
			PLOX_Persistence.GetInstance().ReadVars();
			
			//Initializing SoundManagement
			addChild(new PLOX_SoundManagement());
			
			//
			////////////////////////////////////////////////////////////////////////////////
			
			
			init();
			
			//Start the loading process(es)
			
		}
		
		public function init():void
		{
			// Stop main timeline
			stop();
			
			//We're not done loading yet.
			doneLoading = false;
			
			
			
			//Let the Internationalisation manager load the correct text file
			//i18n.loadTextFiles();
			achievements.loadAchievements();
			
			//Choose the right logo and place it
			logo = new Logo_Big();
			logo.x = stage.stageWidth / 2;
			logo.y = stage.stageHeight * .4;
			logo.width = 276 * (stage.stageHeight / 400);
			logo.height = 131 * (stage.stageHeight / 400);
			addChild(logo);
			var dropShadow : DropShadowFilter = new DropShadowFilter(7,90,0,.45,15,15);
			logo.filters = new Array(dropShadow);
			
			//Create the actual load image
			progressImage = new ProgressImage();
			addChild(progressImage);
			
			//Draw the background
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
			
			// Continue if it's done already
			if ( this.loaderInfo.bytesLoaded == this.loaderInfo.bytesTotal )
			{
				if (loadmanager.doneLoading())
					onMainLoaded()
				else
				{
					trace("We were instantly done loading. Waiting for Load Manager.");
					doneLoading = true;
				}
			}
			else// Otherwise track the load progress
			{
				//Subscribe to the progress event
				this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onMainLoadProgress);
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
		
		
		//Clean up everything, stop loading, remove listeners
		public function destroy():void
		{
			this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onMainLoadProgress);
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
					
			if (play_press)
				stage.addChild(advertisementBar);
		}
		
		
		
		// --------------------------------------------------------------
		// EVENTS
		
		public function onStageResize(event:Event):void
		{
			//centreProgressBar();
		}
		
		public function onMainLoadProgress(e:Event):void
		{
			//Update our loading graphic
			progressImage.UpdatePercentage(this.root.loaderInfo.bytesLoaded / this.root.loaderInfo.bytesTotal);
			
			//Check for load complete
			if (this.root.loaderInfo.bytesLoaded == this.root.loaderInfo.bytesTotal)
			{
				doneLoading = true;
				if (loadmanager.doneLoading())
					onMainLoaded();
				else
					trace("Done loading. Waiting for Load Manager to complete.");
			}
		}
		
		public function onMainLoaded():void
		{
			trace("Loading is complete! "+progressImage);
			destroy();
			
			playButton = new PLOX_PlayButton(this);
			addChild(playButton);
			
			var snd:Sound = new Plox_Ready();
			snd.play();
			
			progressImage.doneLoading = true;
		}
		
		//Clean up all the loading stuff and show the splash screen
		public function advanceToMain():void
		{
			//Clear the entire stage
			graphics.clear();
		
			//Show splash screen
			var splashScreen : PLOX_SplashScreen = new PLOX_SplashScreen(splashTimerDone); // Comment this away if you want to skip the splash screen during the development process
			addChild(splashScreen); // Comment this away if you want to skip the splash screen during the development process
			
			//splashTimerDone(); //Uncomment this if you want to skip the splash screen during the development process
		}
		
		public function splashTimerDone():void{
			trace("Initializing game...");
			
			removeTheChildren();
			
			//Go to frame 2
			//MovieClip(root).gotoAndStop(2);
			
			//Creating main
			var main : PLOX_Main = PLOX_Main.GetInstance();
			play_press = true;
			addChild(main);
			
			addChild(advertisementBar);
			addChild(PLOX_PopUps.GetInstance());
		}
		
		//Helper function remove all children
		private function removeTheChildren():void{
			removeChild(playButton);
			playButton = null;
			removeChild(logo);
			logo = null;
		}
	}
}
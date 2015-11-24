package APIPlox
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class PLOX_Achievements
	{
		private static var achievementsInstance : PLOX_Achievements;
		private var timer:Timer = new Timer(100, 1);
		
		//Temporary list of achievements. Gets automatically moved to Achievements class
		public var achievementList : Array = new Array();
		public var achievementIcons : Array = new Array();
		
		//Achievements go here
		public static const SPLASHTASTIC_MARKETING:PLOX_Achievement = new PLOX_Achievement("Splashtastic Marketing", "Click on the splash logo", 0, 0, aicDefault);
		public static const RETURNING_CUSTOMER:PLOX_Achievement = new PLOX_Achievement("Returning Customer", "Start the game 5 times", 0, 5, aicDefault);
		
		
		private static var location : String;
		
		public static var achievements : Array = new Array();
		
		//List of actual data pairs
		private static var achievementpairs : PLOX_PairLoader;
		
		//PHP Score Loader
		private static var achievementloader:URLLoader;
		
		
		private var loadManager : PLOX_LoadManager;
		private static var localvars:SharedObject;
		private static var online : Boolean;
		
		public function PLOX_Achievements(loadManager : PLOX_LoadManager = null, Online : Boolean = false, Location : String = "plox_api/achievements.php")
		{
			online = Online;
			this.loadManager = loadManager;
			location = Internationalisation.getLocation() + Location;
			
			achievements = achievementList;
		}
		
		public static function GetInstance(loadManager : PLOX_LoadManager = null, Online : Boolean = false, Location : String = "plox_api/achievements.php") : PLOX_Achievements
		{
			if (!achievementsInstance)
				achievementsInstance = new PLOX_Achievements(loadManager, Online, Location);
			
			return achievementsInstance;
		}
		
		public function loadAchievements() : void
		{
			if (online)
			{
				var url:String = location+"?game="+Internationalisation.GetGameNameForWeb()+"&player="+Internationalisation.getPlayerID()+"&type=flash";
				loadManager.registerLoader();
				achievementloader = new URLLoader();
				achievementloader.addEventListener(Event.COMPLETE, achievementsLoaded);
				achievementloader.addEventListener(IOErrorEvent.IO_ERROR, serverNotAvailable);
				achievementloader.load(new URLRequest(url));
			}
			else
			{
				localvars = SharedObject.getLocal("achievements_"+Internationalisation.GetGameNameForWeb());
				timer.addEventListener(TimerEvent.TIMER, localAchievementsLoaded);
				timer.start();
			}
		}
		
		private function localAchievementsLoaded(e:TimerEvent):void
		{
			trace("Loading achievements locally ("+localvars.data.achievementstring+")");
			loadAchievementsFromString(localvars.data.achievementstring);
		}
		
		private function achievementsLoaded(event:Event):void
		{
			loadAchievementsFromString(achievementloader.data);
			
			//When done loading, give the load manager a signal
			if (loadManager)
				loadManager.successfulLoad();
		}
		
		private function serverNotAvailable(event:Event):void
		{
			serverNotAvailableError(event);
			
			//When done loading, give the load manager a signal
			if (loadManager)
				loadManager.successfulLoad();
		}
		
		private static function serverNotAvailableError(event:Event):void
		{
			trace("ERROR: Achievement-server could not be found.");
		}
		
		private function loadAchievementsFromString(source : String) : void
		{
			if (source == null)
				return;
			
			achievementpairs = new PLOX_PairLoader(source, /,/);
			for each (var pair : PLOX_Pair in achievementpairs.getPairs())
			{
				var achievement : PLOX_Achievement = GetAchievement(pair.getKey());
				if (achievement)
					achievement.SetCount(int( pair.getValue() ), true);
			}
		}
		
		public static function ShowProgress(achievement : PLOX_Achievement):void
		{
			if (achievement.GetAchieved())
			{
				trace("=== "+achievement.GetName()+" ===");
				PLOX_PopUps.GetInstance().addAchievementToQueue(achievement);
			}
			else
			{
				//TODO: Should we show progress of achievements as well?
			}
		}
		
		public static function UploadAchievement(achievement : PLOX_Achievement):void
		{
			if (online)
			{
				var url:String = location+"?game="+Internationalisation.GetGameNameForWeb()+"&player="+Internationalisation.getPlayerID()+"&achcount="+achievement.GetCount()+"&achname="+achievement.GetAbsName()+"&type=flash";
				if (achievementloader)
					achievementloader.removeEventListener(Event.COMPLETE, achievementsLoaded);
				achievementloader = new URLLoader();
				achievementloader.addEventListener(IOErrorEvent.IO_ERROR, serverNotAvailableError);
				achievementloader.load(new URLRequest(url));
			}
			else
			{
				localvars.data.achievementstring = GetAchievementString();
				localvars.flush();
			}
		}
		
		private static function achievementsLoaded(event:Event):void
		{
			achievementpairs = new PLOX_PairLoader(achievementloader.data, /,/);
		}
		
		public static function GetAchievement(name : String) : PLOX_Achievement
		{
			for each (var achievement : PLOX_Achievement in achievements)
			{
				if (achievement.GetAbsName() == name)
					return achievement;
			}
			return null;
		}
		
		public static function GetAchievementString() : String
		{
			var string : String = "";
			for each (var achievement : PLOX_Achievement in achievements)
			{
				if (achievement.GetAchieved() || achievement.GetMaxCount()>0)
					string += "\""+achievement.GetAbsName()+"\" = \""+achievement.GetCount()+"\",";
			}
			string = string.substr(0,string.length-1);
			return string;
		}
		
		public static function AchievementReport() : void
		{
			for each (var achievement : PLOX_Achievement in achievements)
			{
				trace("Achievement '"+achievement.GetName() + "' achieved="+achievement.GetAchieved()+" ("+achievement.GetCount()+"/"+achievement.GetMaxCount()+")");
			}
		}
	}
}
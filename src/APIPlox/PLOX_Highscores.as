package APIPlox
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;

	public class PLOX_Highscores
	{
		private static var location : String = "";
		
		//Pair Loader
		private static var scorepairs : PLOX_PairLoader;
		
		//PHP Score Loader
		public static var scoreloader:URLLoader;
		
		private static var listener : Function;
		
		public function PLOX_Highscores(Location : String = "plox_api/scores.php")
		{
			location = Internationalisation.getLocation()+Location;
		}
		
		public static function UpdateScores(time : String = "all", Listener : Function = null) : void
		{
			var timePeriod : String = "&time="+time;
			var url:String = location+"?game="+Internationalisation.GetGameNameForWeb()+"&type=flash"+timePeriod;
			scoreloader = new URLLoader();
			scoreloader.addEventListener(Event.COMPLETE, scoresLoaded);
			//scoreloader.addEventListener(IOErrorEvent.IO_ERROR, serverNotAvailable);
			listener = Listener;
			scoreloader.load(new URLRequest(url));
		}
		
		private static function serverNotAvailable(event:Event):void
		{
			trace("ERROR: High-score server was not found!");
		}
		
		private static function scoresLoaded(event:Event):void
		{
			scorepairs = new PLOX_PairLoader(scoreloader.data, /,/);
			if (listener!=null)
				listener.call(null, event);
		}
		
		public static function AddScore(name : String, score : String) : void
		{			
			var url:String = location+"?game="+Internationalisation.GetGameNameForWeb()+"&winname="+name+"&winscore="+score+"&country="+Internationalisation.GetLanguage()+"&type=flash";
			if (scoreloader)
				scoreloader.removeEventListener(Event.COMPLETE, scoresLoaded);
			scoreloader = new URLLoader();
			scoreloader.addEventListener(IOErrorEvent.IO_ERROR, serverNotAvailable);
			scoreloader.load(new URLRequest(url));
		}
		
		public static function traceScores():void
		{
			if (scorepairs == null)
				trace("The scores have not been loaded yet.");
			else
				trace("The scores are "+scorepairs.toString());
		}
		
		public static function GetScorePairs() : PLOX_PairLoader
		{
			return scorepairs;
		}
	}
}
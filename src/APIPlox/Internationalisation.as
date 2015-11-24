package APIPlox
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.Security;
	
	public class Internationalisation
	{
		private static var gameName : String;
		
		private static var systemLanguage : String;
		private static var supportedLanguages : Array;
		private static var defaultLanguage : String;
		private static var chosenLanguage : String;
		private static var filename : String;
		
		private static var pairloader : PLOX_PairLoader;
		
		private var loadManager : PLOX_LoadManager;
		private var myTextLoader:URLLoader = new URLLoader();
		
		public function Internationalisation(loadManager : PLOX_LoadManager, GameName : String)
		{
			this.loadManager = loadManager;
			
			//Remember the name of the game
			gameName = GameName;
			
			//Get the system language
			systemLanguage = Capabilities.language;
			
			//These are all the supported languages.
			supportedLanguages = ["en", "fr", "nl", "de", "pt", "it", "ja", "zh", "en-US", "en-UK", "es"];
			
			//If the current System Language is not supported, use this instead.
			defaultLanguage = "en";
			
			chosenLanguage = null;
			
			//Check if the current System Language is supported. If so, set the language tcase "that and return.
			for each (var lan : String in supportedLanguages)
			{
				if (systemLanguage == lan)
				{
					chosenLanguage = lan;
					break;
				}
			}
			
			//If the current System Language is not supported, drop the country suffix and try again.
			if (chosenLanguage == null)
			{
				systemLanguage = systemLanguage.substr(0,2);
				for each (lan in supportedLanguages)
				{
					if (systemLanguage == lan)
					{
						chosenLanguage = lan;
						break;
					}
				}
			}
			
			//If we still couldn't find the language, set it to the default value
			if (chosenLanguage == null)
				chosenLanguage = defaultLanguage;
			
		}
		
		
		public function loadTextFiles() : void
		{
			//Load the right text file according to the game name and chosen language
			loadManager.registerLoader();
			myTextLoader.addEventListener(Event.COMPLETE, loadText);
			myTextLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderMissing);
			filename = GetGameNameForWeb()+"_"+chosenLanguage+".txt";
			myTextLoader.load(new URLRequest(filename));
		}
		
		
		//Get the name of the game
		public static function GetGameName() : String
		{
			return gameName;
		}
		//Get the name of the game
		public static function GetGameNameForWeb() : String
		{
			return replaceAll(gameName, " ", "_");
		}
		
		//Get the language of the game
		public static function GetLanguage() : String
		{
			return chosenLanguage;
		}
		
		//Get the link to the website in the country of the player.
		public static function GetLink() : String
		{
			var tempGameName : String = GetGameNameForWeb();
			switch (chosenLanguage)
			{
				case "en-UK": return "http://www.mygame.co.uk/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "nl": return "http://www.spelle.nl/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "fr": return "http://www.jouezgratuitement.fr/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-Las_Vegas_";
				case "it": return "http://www.giocogiochi.it/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "pt": return "http://www.joga.pt/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "br": return "http://www.eujogo.com.br/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "de": return "http://www.spiellen.de/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "pl": return "http://www.gragra.pl/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "ja": return "http://www.flashgames.jp/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "zh": return "http://www.youxiyouxi.cn/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				case "es": return "http://www.juga.es/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
				default: return "http://www.gameitnow.com/?utm_source=game&utm_medium="+tempGameName+"&utm_campaign=link-"+tempGameName+"";
			}
		}
		
		//Get the link to the website in the country of the player.
		public static function GetLinkText() : String
		{
			var tempGameName : String = GetGameNameForWeb();
			switch (chosenLanguage)
			{
				case "en-UK": return "More games at MyGame.co.uk!";
				case "nl": return "Meer spelletjes op Spelle.nl!";
				case "fr": return "Plus de jeux sur JouezGratuitement.fr!";
				case "it": return "Più giochi su GiocoGiochi.it!";
				case "pt": return "Mais jogos em Joga.pt!";
				case "br": return "Mais jogos em EuJogo.com.br!";
				case "de": return "Mehr Spiele auf Spiellen.de!";
				case "pl": return "Więcej gier na GraGra.pl!";
				case "ja": return "FlashGames.jpに関するさらに詳しいゲーム！";
				case "zh": return "在 YouxiYouxi.cn 上免费玩最有趣的游戏！";
				case "es": return "Más juegos en Juga.es!";
				default: return "More games on Gameitnow.com!";
			}
		}
		
		//Get the frame ID for the right logo
		public static function GetLogoFrame() : int
		{
			switch (GetLanguage())
			{
				case "en": return 1;
				case "fr": return 2;
				case "nl": return 3;
				case "de": return 4;
				case "pt": return 5;
				case "it": return 6;
				case "ja": return 7;
				case "zh": return 8;
				case "en-UK": return 9;
				case "es": return 10;
				default:  return 1;
			}
		}
		
		
		
		//TODO: Make this reqest the player name from the browser
		public static function getPlayerName() : String
		{
			return "Roy";
		}
		
		//TODO: Make this get the player id from the database
		public static function getPlayerID() : int
		{
			return 0;
		}
		
		
		
		//Helper function for replacing character
		private static function replaceAll(str:String, fnd:String, rpl:String):String{
			return str.split(fnd).join(rpl);
		}
		
		public function loadText(e:Event):void
		{
			trace("Successfully loading "+filename);
			pairloader = new PLOX_PairLoader(e.target.data, /\n/);
			
			//When done loading, give the load manager a signal
			loadManager.successfulLoad();
		}
		
		//The file did not exist
		public function loaderMissing(event:IOErrorEvent):void
		{
			trace(filename+" does not exist. Trying default language.");
			myTextLoader.addEventListener(Event.COMPLETE, loadText);
			myTextLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderMissingDefault);
			filename = GetGameNameForWeb()+"_"+defaultLanguage+".txt";
			myTextLoader.load(new URLRequest(filename));
		}
		
		//The file did not exist
		public function loaderMissingDefault(event:IOErrorEvent):void
		{
			trace(filename+" does not exist. Abort loading.");
			myTextLoader.close();
			
			//Couldn't load. Will continue anyway.
			loadManager.successfulLoad();
		}
		
		public static function getLocation() : String
		{
			return "http://plox.info/spelle/";
		}
		
		//Look up what the matching value is
		public static function getLabel(key : String) : String
		{
			if (pairloader == null)
				return null;
			else
				return pairloader.getValue(key);
		}
		
		//Look up what the matching value is
		public static function getKey(value : String) : String
		{
			if (pairloader == null)
				return null;
			else
				return pairloader.getKey(value);
		}
		
		public static function Translate(name : String) : String
		{
			var a : String = getLabel(name);
			if (a == null)
				return name;
			else
				return a;
		}
	}
}
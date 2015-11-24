package APIPlox
{
	import APIPlox.Internationalisation;
	import APIPlox.PLOX_PairLoader;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class PLOX_Persistence
	{
		private static var persistence : PLOX_Persistence;
		
		public var persistentvars : Vector.<PLOX_PersistentVar>;

		private static var loader:URLLoader;		
		private static var localvars:SharedObject;
		
		//PERSISTENT VARIABLES
		public static const UNLOCKEDLEVELS : PLOX_PersistentVar = new PLOX_PersistentVar("unlockedlevels", 1);
		
		public function PLOX_Persistence()
		{
			persistentvars = new Vector.<PLOX_PersistentVar>();
		}
		
		public static function GetInstance():PLOX_Persistence
		{
			if (!persistence)
				persistence = new PLOX_Persistence();
			return persistence;
		}
		
		public function ReadVars():void
		{
			var timer:Timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, readVars);
			timer.start();
		}
		private function readVars(e:Event):void
		{
			trace("Reading persistent variables...");
			localvars = SharedObject.getLocal("persistence_"+Internationalisation.GetGameNameForWeb());
			var temp : Array =  localvars.data.persistentvars;
			for each (var a : Array in temp)
			{
				var varname : String = a[0];
				var varvalue : Object = a[1];
				for each (var pv : PLOX_PersistentVar in persistentvars)
				{
					if (pv.name == varname)
					{
						trace("\t\tFound variable "+pv.name+". Setting its value to "+varvalue);
						pv.value = varvalue;
						break;
					}
					//persistentvars.push(new PLOX_PersistentVar(varname, varvalue));
				}
			}
			trace("\t Persistent vars are "+persistentvars);
		}
		public function WriteVars():void
		{
			trace("Writing persistent variables...");
			var temp : Array = new Array();
			for each (var pv : PLOX_PersistentVar in persistentvars)
			{
				trace("\tPersistent variable found: "+pv);
				temp.push([pv.name,pv.value]);
			}
			localvars.data.persistentvars = temp;
			localvars.flush();
		}
	}
}
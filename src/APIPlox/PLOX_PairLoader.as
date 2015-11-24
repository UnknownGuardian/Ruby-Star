package APIPlox
{
	public class PLOX_PairLoader
	{
		private var text : String;
		private var pairs : Array;
		
		public function PLOX_PairLoader(text : String, separator : RegExp)
		{
			this.text = text;
			pairs = new Array();
			if (text == null)
			{
				trace("Tried to load Pairs but text was null!!");
				return;
			}
			var myArrayOfLines:Array = text.split(separator);
			for (var i:int=0; i<myArrayOfLines.length; i++)
			{				
				var line:String = myArrayOfLines[i];
				if (line == "" || line==null || line == " ")
					continue;
				var keystartpos:int = line.indexOf("\"");
				var keyendpos:int = line.indexOf("\"", keystartpos+1);
				
				var valuestartpos:int = line.indexOf("\"", keyendpos+1);
				var valueendpos:int = line.indexOf("\"", valuestartpos+1);
				
				if (line.indexOf("\n", 0) == -1)
					line = line.substring(0, line.length-1);
				
				var key:String = line.substring(keystartpos+1, keyendpos);
				var value:String = line.substring(valuestartpos+1, valueendpos);
				var pair : PLOX_Pair = new PLOX_Pair(key, value);
				pairs.push(pair);
			}
		}
		
		//Look up what the matching key is
		public function getKey(value : String) : String
		{
			for each (var o : Object in pairs)
			{
				if (!(o is PLOX_Pair))
					continue;
				
				var pair : PLOX_Pair = o as PLOX_Pair;
				if (pair.getValue() == value)
					return pair.getKey();
			}
			return null;
		}
		
		//Look up what the matching value is
		public function getValue(key : String) : String
		{
			for each (var o : Object in pairs)
			{
				if (!(o is PLOX_Pair))
					continue;
				
				var pair : PLOX_Pair = o as PLOX_Pair;
				if (pair.getKey() == key)
					return pair.getValue();
			}
			return null;
		}
		
		public function getPairs() : Array
		{
			return pairs;
		}
		
		public function toString():String
		{
			var s : String = "";
			for each (var pair : PLOX_Pair in pairs)
			{
				s=s+pair.toString()+"\n";
			}
			s=s.substr(0, s.length-1);
			return s;
		}
	}
}
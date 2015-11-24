package APIPlox
{
	public class PLOX_Pair
	{
		private var key : String;
		private var value : String;
		
		public function PLOX_Pair(key : String, value : String)
		{
			this.key = key;
			this.value = value;
		}
		
		public function getKey() : String {
			return key;
		}
		
		public function getValue() : String {
			return value;
		}
		
		public function toString():String
		{
			return key+" & "+value;
		}
	}
}
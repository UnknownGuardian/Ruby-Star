package APIPlox
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PLOX_PersistentVar extends Object
	{
		private var initialized : Boolean;
		public var name : String;
		private var _value : Object;
		
		public function PLOX_PersistentVar(name : String, value : Object = null)
		{
			this.name = name;
			if (value)
				this.value = value;
			
			var timer:Timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, init);
			timer.start();
		}
		
		private function init(e:Event):void
		{
			initialized=true;
			PLOX_Persistence.GetInstance().persistentvars.push(this);
		}
		
		public function get value():Object
		{
			return _value;
		}
		public function set value(newvalue:Object):void
		{
			_value = newvalue;
			if (initialized)
				PLOX_Persistence.GetInstance().WriteVars();
		}
		
		public function toString():String
		{
			return "["+name+"="+value+"]";
		}
	}
}
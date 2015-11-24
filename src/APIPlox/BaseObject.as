package APIPlox
{	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class BaseObject extends MovieClip implements IUpdatable
	{
		public var onStage : Boolean;
		public var removed : Boolean; 
		public var paused : Boolean;
		
		private var gameTime : GameTime;
		
		public function BaseObject()
		{
			if (stage)
				Activate(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, Activate, false, 0, true);
			
			PLOX_Statistics.TOTAL_BASEOBJECTS++;
		}
		
		public function Activate(e:Event):void
		{
			if (parent && parent is BaseObject)
			{
				//We are added to a BaseObject. It will loop through its children and call their Update event.
			}
			else
			{
				//We are not added to a BaseObject. This means we have to subscribe to the Update event ourselves.
				gameTime = new GameTime();
				addEventListener(Event.ENTER_FRAME, EventUpdate, false, 0, true);
			}
			removeEventListener(Event.ADDED_TO_STAGE, Activate);
		}
		
		public function Create(object:DisplayObject):void
		{
			if (object && parent)
				parent.addChild(object);
		}
		
		public function EventUpdate(e:Event):void
		{
			if (removed)
				return;
			
			if (!gameTime)
				gameTime = new GameTime();
			
			// Update the gametime
			if (GameTime.MilisecondsPassed == 0)
				GameTime.MilisecondsPassed = getTimer();
			else {
				gameTime.Delta = getTimer() - GameTime.MilisecondsPassed;
				gameTime.Delta /= 16;
				GameTime.MilisecondsPassed = getTimer();
				GameTime.SecondsPassed = getTimer() / 1000;
			}
			//trace("~~~ This is "+this+" and I'm calling my own Update event. ~~~");
			this.Update(gameTime);
			this.LateUpdate(gameTime);
		}
		
		public function Update(gameTime:GameTime):void
		{
			if (paused || removed)
				return;
			for (var i:int=0; i < numChildren; i++) {
				if (getChildAt(i) is IUpdatable)
				{
					var o : IUpdatable = getChildAt(i) as IUpdatable;
					if (!(o is BaseObject) || (o is BaseObject && !BaseObject(o).removed))
					o.Update(gameTime);
				}
			}
		}
		
		public function LateUpdate(gameTime:GameTime):void
		{
			if (paused || removed)
				return;
			for (var i:int=0; i < numChildren; i++) {
				if (getChildAt(i) is IUpdatable)
				{
					var o : IUpdatable = getChildAt(i) as IUpdatable;
					o.LateUpdate(gameTime);
				}
			}
		}
		
		public function Remove() : void
		{
			if (numChildren>0)
			{
				var k:int = numChildren;
				while( k -- )
				{
					if (getChildAt(k) is IUpdatable)
						(getChildAt(k) as IUpdatable).Remove();
					else
						removeChildAt( k );
				}
			}
			if (parent != null)
			{
				parent.removeChild(this);
				PLOX_Statistics.TOTAL_BASEOBJECTS--;
			}
			removeEventListener(Event.ENTER_FRAME, EventUpdate);
			removed = true;
			paused = true;
		}
	}
}
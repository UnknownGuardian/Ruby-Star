package APIPlox
{
	import flash.filters.GlowFilter;
	
	public class Ball extends BaseObject
	{
		public var Y : Number;
		public var phase : Number;
		private var dis : Number = 32;
		
		public function Ball(x:int, y:int)
		{
			super();
			this.x = x;
			this.y = y;
			Y = y;
			Y = y + dis;
			
			phase = 0;
			
			filters = [new GlowFilter(0x0000ff, 1,48,48)];
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			phase += 0.1 * gameTime.Delta;
			y = Y + Math.cos(phase) * dis;
			if (x<stage.stageWidth)
				x+=6*gameTime.Delta;
			else
				Remove();
		}
	}
}
package APIPlox
{	
	import flash.events.Event;
	
	public class PLOX_AchievementsPanel extends PLOX_GUIPanel
	{
		public function PLOX_AchievementsPanel(x:int, y:int, width:int, height:int, radius:int=14, top:int=26, border:int=3, padding:int=5)
		{
			super("Achievements", x, y, width, height, radius, top, border, padding);
			PLOX_Statistics.TOTAL_ACHIEVEMENTSCREENS++;
		}
		
		protected override function init(e:Event):void
		{
			super.init(e);
			//No tabs!
			SetContent(new PLOX_AchievementsOverview(width, height));
		}
		
		public override function Remove():void
		{
			PLOX_Statistics.TOTAL_ACHIEVEMENTSCREENS--;
			super.Remove();
		}
	}
}
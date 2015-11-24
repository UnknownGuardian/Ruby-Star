package APIPlox
{
	import flash.events.Event;

	public class PLOX_LeaderboardsPanel extends PLOX_GUIPanel
	{	
		public function PLOX_LeaderboardsPanel(x:int, y:int, width:int, height:int, radius:int=14, top:int=26, border:int=3, padding:int=5)
		{
			super("Leaderboards", x, y, width, height, radius, top, border, padding);
		}
		
		protected override function init(e:Event):void
		{
			super.init(e);
			
			var newtab : PLOX_Tab;
			
			newtab = new PLOX_Tab("Total", tabwidth, top - 3);
			newtab.SetContent(new PLOX_LeadersPane());
			AddTab(newtab);
			
			newtab = new PLOX_Tab("Day", tabwidth, top - 3);
			newtab.SetContent(new PLOX_LeadersPane("today"));
			AddTab(newtab);
			
			newtab = new PLOX_Tab("Week", tabwidth, top - 3);
			newtab.SetContent(new PLOX_LeadersPane("week"));
			AddTab(newtab);

			newtab = new PLOX_Tab("Month", tabwidth, top - 3);
			newtab.SetContent(new PLOX_LeadersPane("month"));
			AddTab(newtab);
			
		}
	}
}
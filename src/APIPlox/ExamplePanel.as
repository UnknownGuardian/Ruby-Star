package APIPlox
{
	import flash.events.Event;

	public class ExamplePanel extends PLOX_GUIPanel
	{
		/*
		This is an example Panel. It has two tabs, one with a regular Movieclip and one with a Pane.
		Panes are basically the container for your content. It adapts to the size of the GUIPanel it's in.
		
		You can use this to show tables and all sorts of other things.
		
		You can also have a tab that's filled with any other DisplayObject. If this DisplayObject does not fit, scroll-bars will appear.
		*/
		public function ExamplePanel(title:String, x:int, y:int, width:int, height:int, radius:int=14, top:int=26, border:int=3, padding:int=5)
		{
			super(title, x, y, width, height, radius, top, border, padding);
		}
		
		protected override function init(e:Event):void
		{
			super.init(e);
			
			//This is how you add tabs.
			var newtab : PLOX_Tab;				
			newtab = new PLOX_Tab("Movieclip", tabwidth, top - 3);
			newtab.SetContent(new mcHoofdmenu());
			AddTab(newtab);
			
			newtab = new PLOX_Tab("Pane", tabwidth, top - 3);
			newtab.SetContent(new PLOX_LogoPane(getContentWidth(),getContentHeight()));
			AddTab(newtab);
		}
	}
}
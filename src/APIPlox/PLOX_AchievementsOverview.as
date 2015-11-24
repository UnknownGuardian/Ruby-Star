package APIPlox
{	
	import fl.containers.*;
	import fl.controls.*;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PLOX_AchievementsOverview extends BaseObject implements PLOX_Pane
	{
		private var w : int;
		private var h : int;
		
		private var list : Array;
		private var visualisers : Array;
		
		private var content : MovieClip;
		private var scrollpane : ScrollPane;
		
		var spacing : int = 4;
		
		
		public function PLOX_AchievementsOverview(width : int, height : int)
		{
			super();
			
			w = width;
			h = height;
			
			init();
		}
		
		public function Selected():void
		{
			//Nothing
		}
		
		private function init() : void
		{
			
			scrollpane = new ScrollPane();
			content = new MovieClip();
			addChild(scrollpane);
			
			scrollpane.horizontalScrollBar.addEventListener(MouseEvent.MOUSE_UP, _listener, false, 1);
			
			function _listener(e:MouseEvent):void
			{
				//check if the scrollbar is part of the display list
				if (!scrollpane.horizontalScrollBar.stage)
				{
					//It is not in the display list, stop the event from being dispatched to the default dispatcher
					e.stopImmediatePropagation();
				};
			};
			
			//Load the achievements
			list = PLOX_Achievements.achievements;
			visualisers = new Array();
			
			Refresh();
		}
		
		
		public function Resize(newW:int, newH:int):void
		{
			w=newW;
			h=newH;
			
			for each (var ach : PLOX_AchievementVisualizer in visualisers)
			{
				ach.Resize(w,h);
			}
			
			//Realign the scrollpane
			scrollpane.setSize(w,h);
			
			Refresh();
		}
		
		public function Refresh():void
		{
			//Remove all AchievementVisualisers
			for each (var ach : PLOX_AchievementVisualizer in visualisers)
			{
				if (ach && content.contains(ach))
					content.removeChild(ach);
			}
			visualisers = new Array();
			
			//Add all new AchievementVisualisers
			var i : int = 0;
			for each (var a : PLOX_Achievement in list)
			{
				var visualiser : PLOX_AchievementVisualizer = new PLOX_AchievementVisualizer(a, w, h);
				visualiser.y = spacing + ((visualiser.height + spacing) * i);
				content.addChild(visualiser);
				visualisers.push(visualiser);
				i++;
			}
			
			scrollpane.source = content;
		}
		
	}
}
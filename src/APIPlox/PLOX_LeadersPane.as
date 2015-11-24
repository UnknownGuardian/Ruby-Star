package APIPlox
{	
	import fl.containers.*;
	import fl.controls.*;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	//import flashx.textLayout.container.ScrollPolicy;

	public class PLOX_LeadersPane extends BaseObject implements PLOX_Pane
	{
		private var w : int;
		private var h : int;
		
		var scrollpane : ScrollPane;
		
		var leadercount : int;
		var leaderborder : int;
		
		var titleLabel : Label;
		var labelWidth : int;
		var myTextFormat : TextFormat;
		var font : Font;
		
		var labels : Array;
		
		var content : MovieClip;
		var contentDummy : MovieClip;
		
		var time : String;
		
		var listStart : int = 15;
		var listSpace : int = 24;
		
		var bronze : highscore_Bronze;
		var silver : highscore_Silver;
		var gold : highscore_Gold;
		
		//List of actual score pairs
		private static var scorepairs : Array;
		
		public function PLOX_LeadersPane(time : String = "all")
		{
			super();
			
			this.time = time;
			
			w = width;
			h = height;
			
			labels = new Array();
			
			content = new MovieClip();
			contentDummy = new MovieClip();
			
			leadercount = 3;
			leaderborder = 4;
			
			init();
		}
		
		public function Selected():void
		{
			PLOX_Highscores.UpdateScores(time, ScoresLoaded);
			Resize(w,h);
		}
		
		private function ScoresLoaded(event:Event) : void
		{
			removeLabelsOf(content);
			removeLabelsOf(this);
			addChild(scrollpane);
			
			contentDummy = new MovieClip();
			contentDummy.graphics.beginFill(0xff0000, 0);
			contentDummy.graphics.drawCircle(0,0,8);
			contentDummy.graphics.endFill();
			contentDummy.y = 0;
			content.addChild(contentDummy);
			
			scorepairs = PLOX_Highscores.GetScorePairs().getPairs();
			for (var i :int = 0; i<Math.min(leadercount,scorepairs.length); i++)
			{
				if (scorepairs.length<leadercount)
					leadercount=scorepairs.length;
					
				var pair : PLOX_Pair = scorepairs[i];
				if (pair == null)
					continue;
				var share : Number = 1/(leadercount);
				//Replaced with cup icons
				//CreateLabel((share*(i+1)) - (share / 2), 12, "#"+(i+1), 0x000000, 18);
				CreateLabel((share*(i+1)) - (share / 2), 38, pair.getKey(), 0x000000);
				CreateLabel((share*(i+1)) - (share / 2), 50, pair.getValue(), 0x666666);
			}
			
			if (scorepairs.length>leadercount)
			{
				for (i = leadercount; i<scorepairs.length; i++)
				{
					pair = scorepairs[i];
					if (pair == null)
						continue;
					share = .33 / 2;
					CreateLabel(.33 - share, listStart + listSpace*(i-leadercount), "#"+(i+1), 0x000000, 12, true);
					CreateLabel(.66 - share, listStart + listSpace*(i-leadercount), pair.getKey(), 0x000000, 12, true);
					CreateLabel(1 - share, listStart + listSpace*(i-leadercount), pair.getValue(), 0x000000, 12, true);
				}
			}
			
			scrollpane.update();
			
			Resize(w,h);
		}
		
		private function init() : void
		{
			scrollpane = new ScrollPane();
			scrollpane.horizontalScrollPolicy="off";//ScrollPolicy.OFF;
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
			
			Resize(w,h);
		}
		
		public function CreateLabel(X : Number, Y:Number, Text : String, Color : uint, size:Number=12, list:Boolean=false):void
		{
			myTextFormat = new TextFormat();
			font = new Arial();
			myTextFormat.font = font.fontName;
			myTextFormat.color = Color;
			myTextFormat.size = size;
			
			titleLabel = new Label();
			titleLabel.textField.antiAliasType = AntiAliasType.ADVANCED;
			titleLabel.autoSize = TextFieldAutoSize.CENTER;
			titleLabel.setStyle("embedFonts", true);
			titleLabel.setStyle("textFormat", myTextFormat);
			titleLabel.text = Text;
			titleLabel.x = w*X;
			titleLabel.y = Y;
			if (titleLabel.y + 32 > contentDummy.y)
				contentDummy.y = titleLabel.y + 32;
			labels.push(new PLOX_PercentLabel(titleLabel, X, Y, titleLabel.width));
			if (list)
				content.addChild(titleLabel);
			else
				addChild(titleLabel);
		}
		
		public function Resize(newW:int, newH:int):void
		{
			w=newW;
			h=newH;
			
			//Realign the scrollpane
			scrollpane.y = 72;
			scrollpane.setSize(w,h-scrollpane.y);
			
			//Realign the labels
			var i : int = 0;
			for each (var label : PLOX_PercentLabel in labels)
			{
				label.label.x = (w * label.xPercent) - (label.Width/2);
				//label.label.y = label.yPercent*h;
				i++;
			}
			
			Refresh();
		}
		
		public function Refresh():void
		{
			scrollpane.source = content;
			
			graphics.clear();
			var linMatrix:Matrix = new Matrix( );
			linMatrix.createGradientBox( w, 72, (90 * Math.PI / 180) );
			graphics.lineStyle(1,0xe4e4e4);
			graphics.beginGradientFill(GradientType.LINEAR, [0xffffff,0xf6f6f6], [100, 100], [0, 255], linMatrix);
			graphics.drawRoundRect(leaderborder,leaderborder,w-(leaderborder*2),72-(leaderborder*2),16,16);
			graphics.endFill();
			
			graphics.lineStyle(1,0xd4d4d4);
			for (var i : int = 1; i<leadercount; i++)
			{
				graphics.moveTo((w/(leadercount))*i, leaderborder*2);
				graphics.lineTo((w/(leadercount))*i, 72 - leaderborder*2);
			}
			
			content.graphics.clear();
			var I : int;
			if (scorepairs)
			{
				for (i = leadercount; i<scorepairs.length; i++)
				{
					I = i-leadercount;
					if (I & 1)
						continue;
					content.graphics.beginFill(0xf7f7f7);
					content.graphics.drawRect(0,(listStart + listSpace*I)-4, w, 24);
					content.graphics.endFill();
				}
			}
			
			//Gold icon
			if (leadercount > 0)
			{
				if (gold && contains(gold))
					removeChild(gold);
				gold = new highscore_Gold();
				gold.width*=.65;
				gold.height*=.65;
				gold.x = (w/leadercount)*1   - ((w/leadercount)/2) + 2;
				gold.y = 37;
				addChild(gold);
			}
			
			//Silver icon
			if (leadercount>1)
			{
				if (silver && contains(silver))
					removeChild(silver);
				silver = new highscore_Silver();
				silver.width*=.65;
				silver.height*=.65;
				silver.x = (w/leadercount)*2   - ((w/leadercount)/2) + 2;
				silver.y = 37;
				addChild(silver);
			}
			
			//Bronze icon
			if (leadercount>2)
			{
				if (bronze && contains(bronze))
					removeChild(bronze);
				bronze = new highscore_Bronze();
				bronze.width*=.65;
				bronze.height*=.65;
				bronze.x = (w/leadercount)*3   - ((w/leadercount)/2);
				bronze.y = 37;
				addChild(bronze);
			}
			
		}
		
		//Helper function remove all children
		private function removeLabelsOf(mc:MovieClip):void{
			while(mc.numChildren)
			{
				mc.removeChildAt(0);
			}
		}
	}
}
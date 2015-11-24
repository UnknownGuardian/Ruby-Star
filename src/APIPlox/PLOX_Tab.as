package APIPlox
{
	import fl.controls.*;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class PLOX_Tab extends BaseObject
	{
		private var w : int;
		private var h : int;
		private var r : int;
		private var t : String;
		private var top : int;
		private var border : int;
		
		private var active : Boolean;
		
		private var content : DisplayObject; 
		
		private var titleLabel : Label;
		private var myTextFormat:TextFormat
		private var font:Font;
		
		public function PLOX_Tab(title : String, width : int, height : int, radius : int = 9)
		{
			w = width;
			h = height;
			r = radius;
			t = Internationalisation.Translate(title);
			
			addEventListener(MouseEvent.MOUSE_UP, onClick);
			
			titleLabel = new Label();
			myTextFormat = new TextFormat();
			font = new Arial();
			myTextFormat.font = font.fontName;
			myTextFormat.color = 0x000000;
			myTextFormat.size = 12;
			titleLabel.textField.antiAliasType = AntiAliasType.ADVANCED;
			titleLabel.autoSize = TextFieldAutoSize.LEFT;
			titleLabel.setStyle("embedFonts", true);
			titleLabel.setStyle("textFormat", myTextFormat);
			titleLabel.text = t;
			titleLabel.x = 4;
			titleLabel.y = -h + 4;
			addChild(titleLabel);
			
			Refresh();
		}
		
		function onClick(e:MouseEvent)
		{
			if (parent is PLOX_GUIPanel)
			{
				var panel : PLOX_GUIPanel = parent as PLOX_GUIPanel;
				panel.SetActiveTab(this);
			}
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
		}
		
		public function Refresh():void
		{
			w = (t.length * (int(myTextFormat.size)-4)) + 8;
			if (active)
				myTextFormat.color = 0x000000;
			else
				myTextFormat.color = 0xdddddd;
			titleLabel.setStyle("textFormat", myTextFormat);
			
			graphics.clear();
			if (active)
				graphics.beginFill(0xffffff, 1);
			else
				graphics.beginFill(0x000000, 0);
			graphics.drawRoundRectComplex(0,-h,w,h,r,r,0,0);
			graphics.endFill();
		}
		
		public function GetContent() : DisplayObject
		{
			return content;
		}
		
		public function SetContent(content : DisplayObject) : void
		{
			this.content = content;
		}
		
		public function SetActive(active:Boolean):void
		{
			this.active = active;
			if (content is PLOX_Pane && active)
				(content as PLOX_Pane).Selected();
			Refresh();
		}
		
		public function SetWidth(w:int):void
		{
			this.w=w;
			Refresh();
		}
		
		public function SetHeight(h:int):void
		{
			this.h=h;
			Refresh();
		}
		
		public function SetRadius(r:int):void
		{
			this.r=r;
			Refresh();
		}
	}
}
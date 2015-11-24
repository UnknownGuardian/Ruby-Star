package APIPlox
{
	import fl.containers.*;
	import fl.controls.*;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class PLOX_AdvertisementBar extends BaseObject
	{
		private var titleLabel:Label;
		private var labelWidth:int;
		private var font:Font;
		private var labels:Array;
		
		private var myTextFormat:TextFormat;
		private var myTextFormat_highlight:TextFormat;
		
		private var colors:Array;
		private var colors_highlight:Array;
		
		private var bgClass:Class;
		
		private var mouseIsDown:Boolean;
		private var mouseIsOver:Boolean;
		
		private var startWidth:int;
		
		public function PLOX_AdvertisementBar(colors:Array = null, colors_highlight:Array = null, textformat:TextFormat = null, textformat_highlight:TextFormat = null, background:Class = null)
		{
			super();
			
			this.colors = colors;
			this.colors_highlight = colors_highlight;
			this.myTextFormat = textformat;
			this.myTextFormat_highlight = textformat_highlight;
			this.bgClass = background;
			
			if (colors == null)
				this.colors = [0x565656, 0x262626];
			if (colors_highlight == null)
				this.colors_highlight = [0xffffff, 0xbbbbbb];
			
			if (textformat == null)
			{
				myTextFormat = new TextFormat();
				font = new Arial();
				myTextFormat.font = font.fontName;
				myTextFormat.color = 0xffffff;
				myTextFormat.size = 12;
				myTextFormat.bold = true;
			}
			if (textformat_highlight == null)
			{
				myTextFormat_highlight = new TextFormat();
				font = new Arial();
				myTextFormat_highlight.font = font.fontName;
				myTextFormat_highlight.color = 0x000000;
				myTextFormat_highlight.size = 12;
				myTextFormat_highlight.bold = true;
			}
			
			filters = new Array(new DropShadowFilter(4, 180));
			
			//Make the cursor turn into a hand when hovering over us
			this.mouseEnabled = true;
			this.buttonMode = true;
		}
		
		public override function Activate(e:Event):void
		{
			super.Activate(e);
			
			//Add an instance of the given background class
			if (bgClass)
			{
				var bg:DisplayObject = new bgClass();
				bg.width = stage.stageWidth;
				bg.height = 26;
				addChild(bg);
			}
			
			//Add a listener for when the logo is clicked
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			//Create label
			titleLabel = new Label();
			titleLabel.textField.antiAliasType = AntiAliasType.ADVANCED;
			titleLabel.autoSize = TextFieldAutoSize.CENTER;
			titleLabel.setStyle("embedFonts", false);
			titleLabel.setStyle("textFormat", myTextFormat);
			titleLabel.text = Internationalisation.GetLinkText();
			titleLabel.x = stage.stageWidth / 2 - titleLabel.width / 2;
			titleLabel.y = 4;
			titleLabel.mouseEnabled = true;
			titleLabel.buttonMode = true;
			addChild(titleLabel);
			
			Redraw();
		}
		
		private function Redraw():void
		{
			//Draw the background
			y = stage.stageHeight - 26;
			graphics.clear();
			var linMatrix:Matrix = new Matrix();
			linMatrix.createGradientBox(stage.stageWidth, 26, (90 * Math.PI / 180));
			if (mouseIsOver)
			{
				graphics.beginGradientFill(GradientType.LINEAR, colors_highlight, [100, 100], [0, 255], linMatrix);
				titleLabel.setStyle("textFormat", myTextFormat_highlight);
			}
			else
			{
				graphics.beginGradientFill(GradientType.LINEAR, colors, [100, 100], [0, 255], linMatrix);
				titleLabel.setStyle("textFormat", myTextFormat);
			}
			graphics.drawRect(0, 0, stage.stageWidth, 26);
			graphics.endFill();
		}
		
		public function logoClick():void
		{
			var targetURL:URLRequest = new URLRequest(Internationalisation.GetLink());
			navigateToURL(targetURL);
		}
		
		public function mouseUp(event:MouseEvent):void
		{
			if (mouseIsOver)
				logoClick();
			mouseIsDown = false;
			
			Redraw();
		}
		
		public function mouseDown(event:MouseEvent):void
		{
			mouseIsDown = true;
			
			Redraw();
		}
		
		public function rollOver(event:MouseEvent):void
		{
			mouseIsOver = true;
			
			Redraw();
		}
		
		public function rollOut(event:MouseEvent):void
		{
			mouseIsOver = false;
			
			Redraw();
		}
	}
}
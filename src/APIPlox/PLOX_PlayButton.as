package APIPlox
{
	import fl.controls.*;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	public class PLOX_PlayButton extends PLOX_LabelMaker
	{
		private var Width : int;
		private var Height : int;
		
		private var program : Program;
		
		private var mouseIsDown : Boolean;
		private var mouseIsOver : Boolean;
		
		private var dropShadow:DropShadowFilter;
		private var bevel:BevelFilter;
		
		private var scale : Number;
		
		private var graphicClip : MovieClip;
		
		public function PLOX_PlayButton(program:Program)
		{
			super();
			
			this.program = program;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			dropShadow = new DropShadowFilter(4,45,0,.2,10,10);
			
			graphicClip = new MovieClip();
			addChild(graphicClip);
			
			mouseIsDown = false;
			mouseIsOver = false;
			
			//Make the cursor turn into a hand when hovering over us
			this.mouseEnabled = true;
  			this.buttonMode = true;
			
			scale = 0;
		}
		
		private function init(e:Event):void
		{
			Width = 200 * (stage.stageHeight/400);
			Height = 60 * (stage.stageHeight/400);
			
			x = stage.stageWidth/2;
			y = stage.stageHeight*.75;
			Redraw();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			
			graphicClip.x = -Width/2;
			graphicClip.y = -Height/2;
			
			if (scale < 1)
			{
				scale+=0.1;
				Redraw();
			}
			if (scale > 1)
			{
				scale = 1;
				Redraw();
			}
			
			width = Width*scale;
			height = Height*scale;
		}
		
		public override function CreateLabel(X : Number, Y:Number, Text : String, Color : uint, size:Number=12, autoSize:String=TextFieldAutoSize.LEFT, myTextFormat:TextFormat=null):void
		{
			if (labels && stage)
			{
				myTextFormat = new TextFormat();
				font = new Arial();
				myTextFormat.font = font.fontName;
				myTextFormat.color = Color;
				myTextFormat.size = size;
				
				titleLabel = new Label();
				titleLabel.textField.antiAliasType = AntiAliasType.ADVANCED;
				titleLabel.autoSize = autoSize;
				titleLabel.setStyle("embedFonts", true);
				titleLabel.setStyle("textFormat", myTextFormat);
				titleLabel.text = Text;
				titleLabel.x = X - (titleLabel.width/2);
				titleLabel.y = Y - (titleLabel.height * (stage.stageHeight/400));
				labels.push(titleLabel);
				addChild(titleLabel);
			}
		}
		
		private function makeText(color:uint):void
		{
			var f : Number = 1;
			if (stage)
				f = (stage.stageHeight/400);
			CreateLabel(0,0, Internationalisation.Translate("Play"), color, 32 * f, TextFieldAutoSize.CENTER);
		}
		
		public function Redraw():void
		{
			var linMatrix:Matrix = new Matrix( );
			linMatrix.createGradientBox( Width, Height, (90 * Math.PI / 180) );
			graphicClip.graphics.clear();
			
			bevel = new BevelFilter(4,45,16777215,0, 0, .5, 5, 5, 1);
			filters = new Array(dropShadow, bevel);
			
			for each (var label : Label in labels)
			{
				if (label && contains(label))
				removeChild(label);
			}
			
			if (mouseIsOver)
			{
				if (mouseIsDown)
				{
					graphicClip.graphics.beginGradientFill(GradientType.LINEAR, [0x777777,0xbbbbbb], [100, 100], [0, 255], linMatrix);
					bevel = new BevelFilter(4,225,16777215,0, 0, .5, 5, 5, 1);
					filters = new Array(dropShadow, bevel);
					makeText(0x666666);
				}
				else
				{
					graphicClip.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff,0xeeeeee], [100, 100], [0, 255], linMatrix);
					bevel = new BevelFilter(4,45,16777215,0, 0, 0, 5, 5, 1);
					var glow : GlowFilter = new GlowFilter(0xffffff, 1, 12, 12, 2, 3);
					filters = new Array(dropShadow, bevel, glow);
					makeText(0x222222);
				}
			}
			else
			{
				graphicClip.graphics.beginGradientFill(GradientType.LINEAR, [interpolateColor(0xffffff, 0x565656, scale),interpolateColor(0xdddddd, 0x000000, scale)], [100, 100], [0, 255], linMatrix);
				makeText(0xffffff);
			}
			graphicClip.graphics.drawRoundRect(0,0,Width,Height, 20, 20);
			graphicClip.graphics.endFill();
			
			if (!(mouseIsDown && mouseIsOver))
			{
				linMatrix = new Matrix( );
				linMatrix.createGradientBox( Width, Height*.55, (90 * Math.PI / 180) );
				if (mouseIsOver)
					graphicClip.graphics.beginGradientFill(GradientType.LINEAR, [0xcccccc, 0xcccccc], [100, 0], [0, 255], linMatrix);
				else
					graphicClip.graphics.beginGradientFill(GradientType.LINEAR, [0x999999, 0x999999], [100, 0], [0, 255], linMatrix);
				graphicClip.graphics.drawRoundRectComplex(0,0,Width,Height*.45, 10, 10, 0, 0);
				graphicClip.graphics.endFill();
			}
		}
		
		private function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint
		{
			var q:Number = 1-progress;
			var fromA:uint = (fromColor >> 24) & 0xFF;
			var fromR:uint = (fromColor >> 16) & 0xFF;
			var fromG:uint = (fromColor >>  8) & 0xFF;
			var fromB:uint =  fromColor        & 0xFF;
			
			var toA:uint = (toColor >> 24) & 0xFF;
			var toR:uint = (toColor >> 16) & 0xFF;
			var toG:uint = (toColor >>  8) & 0xFF;
			var toB:uint =  toColor        & 0xFF;
			
			var resultA:uint = fromA*q + toA*progress;
			var resultR:uint = fromR*q + toR*progress;
			var resultG:uint = fromG*q + toG*progress;
			var resultB:uint = fromB*q + toB*progress;
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
			return resultColor;  
		}
		
		//This is the eventlistener for the button click event
		public function buttonPressed():void{
			program.advanceToMain();
		}
		
		public function mouseUp(event:MouseEvent):void{
			if (mouseIsOver)
				buttonPressed();
			mouseIsDown = false;
			
			Redraw();
		}
		
		public function mouseDown(event:MouseEvent):void{
			mouseIsDown = true;
			
			Redraw();
		}
		
		public function rollOver(event:MouseEvent):void{
			mouseIsOver = true;
			
			Redraw();
		}
		
		public function rollOut(event:MouseEvent):void{
			mouseIsOver = false;
			
			Redraw();
		}
		
	}
}
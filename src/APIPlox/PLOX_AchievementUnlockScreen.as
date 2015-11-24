package APIPlox
{	
	import fl.containers.*;
	import fl.controls.*;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class PLOX_AchievementUnlockScreen extends BaseObject
	{
		private var W : int;
		private var H : int;
		private var w : int;
		private var h : int;
		
		private var scale : Number;
		
		private var border : int = 5;
		
		private var a : PLOX_Achievement;
		private var icon : MovieClip;
		
		
		public var titleLabel : Label;
		public var labelWidth : int;
		public var myTextFormat : TextFormat;
		public var font : Font;
		
		
		private var splashStartTime : Number;
		
		public function PLOX_AchievementUnlockScreen(achievement : PLOX_Achievement)
		{
			super();
			a = achievement;
			
			icon = a.GetIcon();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(15,45,0,.45,20,20);
			filters = new Array(dropShadow);
			
			alpha=0;
			W = 375;
			H = 75;
			scale = 0;
			splashStartTime = getTimer();
		}
		
		private function onAddedToStage(e:Event):void
		{
			Refresh();
			CreateLabel(h + border, 4, Internationalisation.Translate("ACHIEVEMENT UNLOCKED!"), 0xffffff, 16);
			var l : Label = CreateLabel(h + border, 32, a.GetDescription(), 0xffffff, 12);
			icon.x = (h/2) - 25;
			icon.y = (h/2) - 25;
			addChild(icon);
		}
		
		public override function Update(gameTime:GameTime):void
		{
			//scale += .00035 * gameTime.Delta;
			width = W * scale;
			height = H * scale;
			
			x = root.stage.stageWidth/2 - width/2;
			y = (root.stage.stageHeight - h) - height/2;
			
			//trace("Unlock update "+scale);
			if (GameTime.MilisecondsPassed-splashStartTime < 2000)
			{
				if (alpha<1)
					alpha += .035 * gameTime.Delta;
				if (scale<1)
					scale += .075 * gameTime.Delta;
				else
					scale=1;
			}
			if (GameTime.MilisecondsPassed-splashStartTime > 4000)
			{
				if (alpha>0)
					alpha -= .08 * gameTime.Delta;
				else
				{
					PLOX_PopUps.GetInstance().removeAchievementFromQueue();
				}
				scale -= .1 * gameTime.Delta;
			}
		}
		
		public function Refresh():void
		{
			//if (root.stage.stageWidth < 550)
				//scale = root.stage.stageWidth / 550;
			
			w = W;
			h = H;
			
			var linMatrix:Matrix = new Matrix( );
			linMatrix.createGradientBox( w, h, (90 * Math.PI / 180) );
			
			graphics.clear();
			
			graphics.beginGradientFill(GradientType.LINEAR, [0x565656,0x262626], [100, 100], [0, 255], linMatrix);
			graphics.drawRoundRect(0,0, w, h, h, h);
			graphics.endFill();
			
			graphics.beginGradientFill(GradientType.LINEAR, [0xffffff,0xeeeeee], [100, 100], [0, 255], linMatrix);
			graphics.drawEllipse(border, border, h-border*2, h-border*2);
			graphics.endFill();
			
			//border
		}
		
		public function CreateLabel(X : Number, Y:Number, Text : String, Color : uint, size:Number=12):Label
		{
			myTextFormat = new TextFormat();
			//font = new Arial();
			myTextFormat.font = "Arial";//font.fontName;
			myTextFormat.color = Color;
			myTextFormat.size = size;
			
			titleLabel = new Label();
			titleLabel.textField.antiAliasType = AntiAliasType.ADVANCED;
			titleLabel.autoSize = TextFieldAutoSize.LEFT;
			titleLabel.setStyle("embedFonts", true);
			titleLabel.setStyle("textFormat", myTextFormat);
			titleLabel.text = Text;
			titleLabel.x = X;
			titleLabel.y = Y;
			addChild(titleLabel);
			
			return titleLabel;
		}
	}
}
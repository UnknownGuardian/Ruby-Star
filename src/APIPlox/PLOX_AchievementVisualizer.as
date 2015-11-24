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
	
	public class PLOX_AchievementVisualizer extends MovieClip
	{
		private var w : int;
		private var h : int;
		
		var labels : Array;
		var icon : DisplayObject;
		var a : PLOX_Achievement;
		
		var titleLabel : Label;
		var labelWidth : int;
		var myTextFormat : TextFormat;
		var font : Font;
		
		var padding : int = 32;
		var achievementHeight : int = 64;
		var achievementSpacing : int = 4;
		var achievementPadding : int = 6;
		
		public function PLOX_AchievementVisualizer(achievement : PLOX_Achievement, width : int, height : int)
		{
			labels = new Array();
			this.a = achievement;
			
			w = width;
			h = height;
			
			icon = a.GetIcon();
			icon.x = achievementPadding;
			icon.y = achievementPadding;
			addChild(icon);
			
			x = padding * .65;
			
			Resize(w,h);
		}
		
		public function CreateLabel(X : Number, Y:Number, Text : String, Color : uint = 0x000000, size:Number=12, bold:Boolean=false):void
		{
			titleLabel = new Label();
			UpdateLabel(titleLabel, X,Y,Text,Color,size, bold);
			addChild(titleLabel);
			labels.push(titleLabel);
		}
		
		private function UpdateLabel(label : Label, X : Number, Y:Number, Text : String, Color : uint = 0x000000, size:Number=12, bold:Boolean=false)
		{
			myTextFormat = new TextFormat();
			font = new Arial();
			myTextFormat.font = font.fontName;
			myTextFormat.color = Color;
			myTextFormat.size = size;
			myTextFormat.bold = bold;
			
			label.textField.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.setStyle("embedFonts", true);
			label.setStyle("textFormat", myTextFormat);
			label.text = Text;
			label.x = X;
			label.y = Y;
		}
		
		public function Resize(newW:int, newH:int):void
		{
			w=newW - (padding*2);
			h=newH;
			
			Refresh();
		}
		
		public function Refresh():void
		{
			var linMatrix:Matrix = new Matrix( );
			linMatrix.createGradientBox( w, achievementHeight, (90 * Math.PI / 180) );
			
			//Remove all labels
			for each (var label : Label in labels)
			{
				if (label && contains(label))
					removeChild(label);
			}
			labels = new Array();
			
			//Remove icon
			//if (icon && contains(icon))
				//removeChild(icon);
			
			icon.x = achievementPadding;
			icon.y = achievementPadding;
			if (a.GetAchieved())
				icon.alpha = 1;
			else
				icon.alpha = .5;
			
			graphics.clear();
			var newColor : uint;
			if (a.GetAchieved())
				graphics.beginGradientFill(GradientType.LINEAR, [0xd6edaa,0xbcd984], [100, 100], [0, 255], linMatrix);
			else
				graphics.beginGradientFill(GradientType.LINEAR, [0xededed,0xdddddd], [100, 100], [0, 255], linMatrix);
			graphics.drawRoundRect(0,0,w,achievementHeight,16,16);
			graphics.endFill();
			
			graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa,0x737373], [100, 100], [0, 255], linMatrix);
			graphics.drawRect(achievementPadding,achievementPadding,achievementHeight - (achievementPadding*2),achievementHeight - (achievementPadding*2));
			graphics.endFill();
			
			
			if (a.GetMaxCount() > 0)
			{
				graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa,0x737373], [100, 100], [0, 255], linMatrix);
				graphics.drawRect(3 + achievementHeight,(achievementPadding+achievementHeight)-(achievementPadding*2)-16,  (w-achievementPadding*2)  -  (3 + achievementHeight),16);
				graphics.endFill();
				if (a.GetAchieved())
					graphics.beginGradientFill(GradientType.LINEAR, [0x7e9aff,0x7e9aff], [100, 100], [0, 255], linMatrix);
				else
					graphics.beginGradientFill(GradientType.LINEAR, [0xd4caff,0x9e87ff], [100, 100], [0, 255], linMatrix);
				graphics.drawRect(3 + achievementHeight,(achievementPadding+achievementHeight)-(achievementPadding*2)-16,  ((w-achievementPadding*2)  -  (3 + achievementHeight))*a.GetProgress(),16);
				graphics.endFill();
			}
			
			//Create the labels
			newColor = 0x555555;
			if (a.GetAchieved())
				newColor = 0x000000;
			CreateLabel(achievementPadding + (achievementHeight - (achievementPadding*2)) + achievementPadding, 6, a.GetName(), newColor, 12, true);
			CreateLabel(achievementPadding + (achievementHeight - (achievementPadding*2)) + achievementPadding, 24, a.GetDescription(), newColor, 11);
			
		}
		
	}
}
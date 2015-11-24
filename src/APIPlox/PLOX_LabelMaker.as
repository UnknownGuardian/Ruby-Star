package APIPlox
{
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

	public class PLOX_LabelMaker extends BaseObject
	{
		public var titleLabel : Label;
		public var labelWidth : int;
		public var myTextFormat : TextFormat;
		public var font : Font;
		
		protected var labels : Array;
		
		public function PLOX_LabelMaker()
		{
			super();
			labels = new Array();
		}
		
		public function CreateLabel(X : Number, Y:Number, Text : String, Color : uint, size:Number=12, autoSize:String=TextFieldAutoSize.LEFT, myTextFormat:TextFormat=null):void
		{
			if (!myTextFormat)
			{
				myTextFormat = new TextFormat();
				font = new Arial();
				myTextFormat.font = font.fontName;
				myTextFormat.color = Color;
				myTextFormat.size = size;
			}
			this.myTextFormat = myTextFormat;
			
			titleLabel = new Label();
			titleLabel.textField.antiAliasType = AntiAliasType.ADVANCED;
			titleLabel.autoSize = autoSize;
			titleLabel.setStyle("embedFonts", true);
			titleLabel.setStyle("textFormat", myTextFormat);
			titleLabel.text = Text;
			if (autoSize != TextFieldAutoSize.CENTER)
			{
				titleLabel.x = X;
				titleLabel.y = Y;
			}
			else
			{
				titleLabel.x = X - (titleLabel.width/2);
				titleLabel.y = Y - (titleLabel.height/2);
			}
			labels.push(titleLabel);
			addChild(titleLabel);
		}
	}
}
package APIPlox
{
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	public class ProgressImage extends BaseObject
	{
		private var Width : int;
		private var Height : int;
		
		private var barClip : MovieClip;
		
		private var scale : Number;
		
		public var doneLoading : Boolean;
		
		public function ProgressImage()
		{
			super();
			Width = 320;
			Height = 16;
			
			barClip = new MovieClip();
			addChild(barClip);
			
			scale = 1;
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			if (scale > 0)
				width = Width/scale;
			else
				width = 0;
			height = Height*scale;
			
			if (doneLoading)
			{
				if (scale>0)
					scale-=.05;
				else
					scale=0;
			}
		}
		
		public function UpdatePercentage(percentage:Number):void
		{
			var linMatrix:Matrix = new Matrix( );
			linMatrix.createGradientBox( Width, Height, (90 * Math.PI / 180) );
			
			x=(stage.stageWidth/2);
			y=(stage.stageHeight*.75)-Height/2;
			
			barClip.graphics.clear();
			barClip.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff,0xffc55b], [100, 100], [0, 255], linMatrix);
			barClip.graphics.drawRect(-Width/2,0,Width*percentage,Height);
			barClip.graphics.endFill();
			
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, [0xff0000,0x000000], [100, 100], [0, 255], linMatrix);
			graphics.drawRect(-Width/2 + Width*percentage,0,Width*(1-percentage),Height);
			graphics.endFill();
			
			var glow : GlowFilter = new GlowFilter(0xffffff, 1, 7, 7, 2, 3);
			barClip.filters = new Array(glow);
		}
	}
}
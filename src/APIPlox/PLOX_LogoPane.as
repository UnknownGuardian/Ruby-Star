package APIPlox
{
	public class PLOX_LogoPane extends BaseObject implements PLOX_Pane
	{
		private var logo : Logo_Small;
		private var w : int;
		private var h : int;
		
		public function PLOX_LogoPane(width : int, height : int)
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
			logo = new Logo_Small();
			logo.gotoAndStop(Internationalisation.GetLogoFrame());
			addChild(logo);
			
			Refresh();
		}
		
		public function Resize(newW:int, newH:int):void
		{
			w=newW;
			h=newH;
			Refresh();
		}
		
		public function Refresh():void
		{
			graphics.clear();
			graphics.beginFill(0x121245, 1);
			graphics.drawRoundRect(0,0,w,h,16,16);
			graphics.endFill();
			
			logo.x = w/2;
			logo.y = h/2;
		}
	}
}
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
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PLOX_GUIPanel extends BaseObject implements PLOX_Pane
	{
		var w : int;
		var h : int;
		var r : int;
		var top : int;
		var border : int;
		var padding : int;
		var triangleSize : int;
		var resizeLineSpacing : int;
		
		var dragging : Boolean;
		var resizing : Boolean;
		var clickX : int;
		var clickY : int;
		var clickW : int;
		var clickH : int;
		
		var tabwidth : int;
		
		var tabs : Array;
		var activetab : PLOX_Tab;
		
		var content : DisplayObject;
		
		var title : String;
		var scrollpane : ScrollPane;
		var borderfixer : MovieClip;
		var closeButton : Button;
		var closeButtonPressed : Boolean;
		var titleLabel : Label;
		var labelWidth : int;
		var myTextFormat : TextFormat;
		var font : Font;
		
		public function PLOX_GUIPanel(title : String, x : int, y : int, width : int, height : int, radius : int = 14, top : int = 26, border : int = 3, padding : int = 5)
		{
			super();
			
			this.title = Internationalisation.Translate(title);
			this.x=x;
			this.y=y;
			w = width;
			h = height;
			r = radius;
			this.top = top;
			this.border = border;
			this.padding = padding;
			
			//Size of the little resize triangle in the bottom-right corner
			triangleSize = padding*2;
			resizeLineSpacing = 4;
			
			tabs = new Array();
		}
		
		public override function Activate(e:Event):void
		{
			super.Activate(e);
			init(e);
		}
		
		protected function init(e:Event):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePressed);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseReleased);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved);
			
			tabwidth = 68;
			
			content = new MovieClip();
			
			closeButton = new Button();
			closeButton.label = Internationalisation.Translate("Close");
			closeButton.width = 70;
			closeButton.height = 20;
			addChild(closeButton);
			closeButton.addEventListener(MouseEvent.CLICK, onClose);
			
			scrollpane = new ScrollPane();
			scrollpane.source = content;
			addChild(scrollpane);
			borderfixer = new MovieClip();
			addChild(borderfixer);
			
			titleLabel = new Label();
			myTextFormat = new TextFormat();
			font = new Arial();
			myTextFormat.font = font.fontName;
			myTextFormat.color = 0xffffff;
			myTextFormat.size = 12;
			titleLabel.textField.antiAliasType = AntiAliasType.ADVANCED;
			titleLabel.autoSize = TextFieldAutoSize.RIGHT;
			titleLabel.setStyle("embedFonts", true);
			titleLabel.setStyle("textFormat", myTextFormat);
			titleLabel.text = title;
			labelWidth = titleLabel.width;
			titleLabel.y = 4;
			addChild(titleLabel);
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(4,45,0,.3,10,10);
			filters = new Array(dropShadow);
			
			Refresh();
		}
		
		protected function AddTab(tab : PLOX_Tab):void
		{
			if (tabs.length > 0)
			{
				var lasttab : PLOX_Tab = PLOX_Tab(tabs[tabs.length-1]);
				tab.x = lasttab.x + lasttab.width;
			}
			else
				tab.x = 0;
			tab.y = top;
			addChild(tab);
			tabs.push(tab);
			
			Refresh();
		}
		
		public function SetActiveTab(activetab : PLOX_Tab):void
		{
			this.activetab = activetab;
			for each (var tab : PLOX_Tab in tabs)
			{
				if (tab == activetab)
					tab.SetActive(true);
				else
					tab.SetActive(false);
			}
			if (activetab)
			{
				SetContent(activetab.GetContent());
			}
			Refresh();
		}
		
		public function SetContent(newContent : DisplayObject):void
		{
			content = newContent;
			scrollpane.source = content;
			if (content is PLOX_Pane)
			{
				scrollpane.horizontalScrollPolicy = "off";//ScrollPolicy.OFF;
				scrollpane.verticalScrollPolicy = "off";//ScrollPolicy.OFF;
				(content as PLOX_Pane).Resize(getContentWidth(), getContentHeight());
			}
			else
			{
				scrollpane.horizontalScrollPolicy = "auto";//ScrollPolicy.AUTO;
				scrollpane.verticalScrollPolicy = "auto";//ScrollPolicy.AUTO;
			}
		}
		
		public function getContentWidth() : int
		{
			return scrollpane.width;
		}
		public function getContentHeight() : int
		{
			return scrollpane.height;
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			if (!activetab && tabs.length>0)
				SetActiveTab(tabs[0]);
		}
		
		
		public function Refresh():void
		{
			//Draw the Panel itself
			graphics.clear();
			var linMatrix:Matrix = new Matrix( );
			linMatrix.createGradientBox( w, h, (90 * Math.PI / 180) );
			graphics.beginGradientFill(GradientType.LINEAR, [0x565656,0x262626], [100, 100], [0, (top/h)*255], linMatrix);
			graphics.drawRoundRectComplex(-border,-border,w+border*2,h+border*2,r+border,r+border,0,0);
			graphics.endFill();
			
			graphics.beginGradientFill(GradientType.LINEAR, [0xffffff,0xeeeeee], [100, 100], [((h-closeButton.height)/h)*255, 255], linMatrix);
			if (top > 0)
				graphics.drawRoundRectComplex(0,top,w,h-top,0,0,0,0);
			else
				graphics.drawRoundRectComplex(0,top,w,h-top,r,r,0,0);
			graphics.endFill();
			
			for (var d:int = resizeLineSpacing; d<triangleSize; d+=resizeLineSpacing)
			{
				graphics.lineStyle(1, 0x777777);
				graphics.moveTo(w-d, h);
				graphics.lineTo(w, h-d);
				graphics.lineStyle();
			}
			
			//Realing the tabs and refresh them
			for each (var tab : PLOX_Tab in tabs)
			{
				tab.Refresh();
			}
			
			//Realign the title
			titleLabel.x = w - labelWidth - 4;
			
			//Realign the close button
			closeButton.x = w-closeButton.width-padding;
			closeButton.y = h-closeButton.height-padding;
			
			//Realign the scrollpane
			scrollpane.x = padding;
			scrollpane.y = top+padding;
			scrollpane.setSize(w-(padding*2),h-top-closeButton.height-(padding*3));
			borderfixer.x = scrollpane.x;
			borderfixer.y = scrollpane.y;
			
			//Redraw the border-fixer
			borderfixer.graphics.clear();
			borderfixer.graphics.beginFill(0xffffff);
			borderfixer.graphics.drawRect(-padding, 0, padding, scrollpane.height);
			borderfixer.graphics.drawRect(scrollpane.width, 0, padding, scrollpane.height);
			borderfixer.graphics.drawRect(0, scrollpane.height, scrollpane.width, padding);
			borderfixer.graphics.endFill();
		}
		
		public function MoveTo(newX : int, newY : int):void
		{
			x = newX;
			y = newY;
			
			if (x<0)
				x=0;
			if (y<0)
				y=0;
			
			if (x>stage.stageWidth-w)
				x=stage.stageWidth-w;
			
			if (y>stage.stageHeight-h)
				y=stage.stageHeight-h;
		}
		
		public function Resize(newW : int, newH : int):void
		{
			var minW : int = labelWidth + 8;
			var minH : int = top + closeButton.height + (padding*3) + 28;
			if (tabs.length > 0)
			{
				var lasttab : PLOX_Tab = PLOX_Tab(tabs[tabs.length-1]);
				minW += lasttab.x + lasttab.width;
			}
			w = Math.max(newW, minW);
			h = Math.max(newH, minH);
			
			var excW : int = Math.max(0, (x+w) - stage.stageWidth);
			var excH : int = Math.max(0, (y+h) - stage.stageHeight);
			w-=excW;
			h-=excH;
			
			//If the content tries to fill out the window, update its size
			if (content is PLOX_Pane)
				(content as PLOX_Pane).Resize(getContentWidth(),getContentHeight());
			
			Refresh();
		}
		
		public function Selected():void
		{
			//Nothing
		}
		
		protected function mouseInResizeArea(X : Number, Y : Number) : Boolean
		{
			var n :Number = Math.max(0, (Y-(h-triangleSize)) );
			if (Y > h-(triangleSize) && X > w-n)
				return true;
			else
				return false
		}
		
		function onMouseMoved(e:MouseEvent)
		{
			if (dragging)
			{
				MoveTo(e.stageX - clickX, e.stageY - clickY);
			}
			
			if (resizing)
			{
				Resize(clickW + (e.stageX - clickX),clickH + (e.stageY - clickY)); 
			}
		}
		function onMousePressed(e:MouseEvent)
		{
			var minX : int = 8;
			if (tabs.length > 0)
			{
				var lasttab : PLOX_Tab = PLOX_Tab(tabs[tabs.length-1]);
				minX += lasttab.x + lasttab.width;
			}
			
			if (e.localY <= top && e.localX > minX && e.localX<w-labelWidth)
			{
				dragging = true;
				clickX = e.localX;
				clickY = e.localY;
			}
			
			if (mouseInResizeArea(e.localX, e.localY))
			{
				resizing = true;
				clickW = w;
				clickH = h;
				
				clickX = e.stageX;
				clickY = e.stageY;
			}
		}
		function onMouseReleased(e:MouseEvent)
		{
			dragging = false;
			resizing = false;
		}
		
		function onClose(e:MouseEvent)
		{
			Remove();
		}
	}
}
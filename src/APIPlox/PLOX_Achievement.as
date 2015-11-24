package APIPlox
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.utils.Timer;

	public class PLOX_Achievement extends MovieClip
	{
		private var title : String;
		private var description : String;
		private var count : int;
		private var maximumcount : int;
		private var achieved : Boolean;
		private var achievementiconClass : Class;
		
		public function PLOX_Achievement(title : String, description : String, count : int, maximumcount : int, image : Class)
		{
			this.title = title;
			this.description = description;
			this.count = count;
			this.maximumcount = maximumcount;
			this.achievementiconClass = image;
			
			var timer:Timer = new Timer(1, 1);
			timer.addEventListener(TimerEvent.TIMER, init);
			timer.start();
		}
		
		private function init(e:Event):void
		{
			PLOX_Achievements.GetInstance().achievementList.push(this);
		}
		
		public function SetCount(count : int, silent : Boolean = false):void
		{
			this.count = Math.min(count, maximumcount);
			
			if (count >= maximumcount)
			{
				Achieve(silent);
				count = maximumcount;
			}
			else
			{
				PLOX_Achievements.UploadAchievement(this);
				if (!silent)
				{
					if (count == maximumcount/4 ||
						count == maximumcount/2 ||
						count == maximumcount*(3/4))
						PLOX_Achievements.ShowProgress(this);
				}
			}
		}
		
		public function IncrementCount(count : int = 1):void
		{
			SetCount(GetCount()+count);
		}
		
		public function GetCount() : int
		{
			return count;
		}
		
		public function GetMaxCount() : int
		{
			return maximumcount;
		}
		
		public function GetProgress() : Number
		{
			if (maximumcount == 0)
				return -1;
			else
				return count/maximumcount;
		}
		
		public function Achieve(silent : Boolean = false) : void
		{
			if (achieved == true)
				silent=true;
			achieved = true;
			PLOX_Achievements.UploadAchievement(this);
			if (!silent)
			PLOX_Achievements.ShowProgress(this);
		}
		
		public function GetAchieved() : Boolean
		{
			return achieved;
		}
		
		public function GetAbsName() : String
		{
			return title;
		}
		
		public function GetName() : String
		{
			return Internationalisation.Translate(title);
		}
		
		public function GetAbsDescription() : String
		{
			return description;
		}
		public function GetDescription() : String
		{
			return Internationalisation.Translate(description);
		}
		
		public function GetIcon() : MovieClip
		{
			var icon : MovieClip = new achievementiconClass();
			icon.width = Math.min(icon.width, 50);
			icon.height = Math.min(icon.height, 50);
			return icon;
		}
	}
}
package APIPlox
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	
	public class PLOX_PopUps extends BaseObject
	{
		private static var popUps : PLOX_PopUps; 
		
		private var achievementQueue : Array;
		private var achievementQueueNewest : MovieClip;
		
		public function PLOX_PopUps()
		{
			super();
			achievementQueue = new Array();
		}
		
		public static function GetInstance() : PLOX_PopUps
		{
			if (popUps)
				return popUps;
			else
			{
				popUps = new PLOX_PopUps();
				return popUps;
			}	
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			if (achievementQueue.length > 0 && achievementQueueNewest==null)
				removeAchievementFromQueue();
		}
		
		public function addAchievementToQueue(achievement : PLOX_Achievement) : void
		{
			achievementQueue.push(achievement);
			var snd:Sound = new Plox_Achievement();
			snd.play();
		}
		public function removeAchievementFromQueue() : void
		{
			if (achievementQueueNewest && contains(achievementQueueNewest))
			{
				removeChild(achievementQueueNewest);
				achievementQueueNewest = null;
			}
			
			if (achievementQueue.length>0)
			{
				var achievement : PLOX_Achievement = PLOX_Achievement(achievementQueue[0]);
				achievementQueueNewest=new PLOX_AchievementUnlockScreen(achievement);
				achievementQueue.splice(0,1);
				addChild(achievementQueueNewest);
			}
		}
	}
}
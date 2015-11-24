package APIPlox
{
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class PLOX_SoundManagement extends BaseObject
	{
		public static var SOUND_ON : Boolean = true;
		
		private static var preferredmusic : Sound;
		private static var channel:SoundChannel;
		
		public function PLOX_SoundManagement()
		{
			Activate(null);
		}
		
		public static function PlayMusic(snd : Sound):void
		{
			if (preferredmusic == snd)
				return;
			
			StopMusic();
			channel = new SoundChannel();
			preferredmusic = snd;
			channel = preferredmusic.play(0,9999999999);
		}
		
		public override function Update(gameTime:GameTime):void
		{
			super.Update(gameTime);
			if (SOUND_ON)
			{
				if (preferredmusic && !channel)
				{
					PlayMusic(preferredmusic);
				}
			}
			else
			{
				StopMusic();
			}
		}
		
		public static function StopMusic():void
		{
			if (preferredmusic && channel)
			{
				channel.stop();
				channel = null;
			}
		}
	}
}
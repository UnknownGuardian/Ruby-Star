package APIPlox
{
	import flash.events.ProgressEvent;

	public class PLOX_LoadManager
	{
		private var loadersRegistered : int = 0;
		private var program : Program;
		
		public function PLOX_LoadManager(program : Program)
		{
			this.program = program;
			trace("LoadManager created");
		}
		
		public function successfulLoad():void
		{
			loadersRegistered--;
			trace("Succesfully loaded! ("+loadersRegistered+" items left in queue)");
			
			//If the game is done loading and waiting for us, tell it that we're done loading as well
			if (doneLoading())
			{
				trace("LoadManager is done loading! ");
				if (program.doneLoading)
					program.onMainLoaded();
			}
		}
		
		public function registerLoader():void
		{
			loadersRegistered++;
			trace("Loader registered! ("+loadersRegistered+" items left in queue)");
		}
		
		public function doneLoading() : Boolean
		{
			return loadersRegistered <= 0
		}
		
		
	
	}
}
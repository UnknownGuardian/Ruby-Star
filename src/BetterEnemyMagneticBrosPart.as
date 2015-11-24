package  
{
	import ugLabs.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyMagneticBrosPart extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public function BetterEnemyMagneticBrosPart() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.magneticBros, 80, 60, 30, true , false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			setHealth(100);
		}
		
		
		override public function frame():void
		{
			
		}
		
		
		override public function kill():void
		{
			super.kill()
			DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			
			var explosion:BetterExplosion = new BetterExplosion();
			explosion.x = x;
			explosion.y = y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
			
			spriteSheet.destroy();
		}
	}

}
package  
{
	import ugLabs.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyBlobule extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public var speed:Number = 1;
		
		public var xSpeed:Number;
		public var ySpeed:Number;
		
		public var dir:Number = 0;
		
		public function BetterEnemyBlobule() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.blobule, 45, 50, 21, true, false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			dir = Math.random() * 360;
			
			xSpeed = Math.cos(dir * (Math.PI / 180)) * speed;
			ySpeed = Math.sin(dir * (Math.PI / 180)) * speed;			
		}
		
		override public function frame():void
		{
			x += xSpeed;
			y += ySpeed;
			
			//check bounds
			var p:ScrollingBackground = ScrollingBackground(Layers.Background);
			if (x < width/2)
			{
				x = width/2;
				
				//how the wall collision effects ship
				xSpeed *= -1;
			}
			else if (x > p.WIDTH - width/2)
			{
				x = p.WIDTH - width / 2;
				
				//how the wall collision effects ship
				xSpeed *= -1;
			}
			if (y < height/2)
			{
				y = height/2;
				
				//how the wall collision effects ship
				ySpeed *= -1;
			}
			else if (y > p.HEIGHT - height/2)
			{
				y = p.HEIGHT - height/2;
				
				//how the wall collision effects ship
				ySpeed *= -1;
			}
		}
		
		
		
		override public function applyDamage(num:Number):void
		{
			super.applyDamage(num);
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
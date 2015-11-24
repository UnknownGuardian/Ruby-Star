package APIPlox
{
	public interface IUpdatable
	{
		function Update(gameTime : GameTime) : void;
		function LateUpdate(gameTime : GameTime) : void;
		function Remove() : void;
	}
}
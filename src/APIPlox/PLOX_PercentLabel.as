package APIPlox
{
	import fl.controls.Label;
	
	public class PLOX_PercentLabel
	{
		var label : Label;
		var xPercent : Number;
		var yPercent : Number;
		var Width : int;
		
		public function PLOX_PercentLabel(label : Label, xPercent : Number, yPercent : Number, Width : int)
		{
			this.label = label;
			this.xPercent = xPercent;
			this.yPercent = yPercent;
			this.Width = Width;
		}
	}
}
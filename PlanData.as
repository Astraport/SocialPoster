package
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class PlanData extends EventDispatcher
	{
		public var uid:String;
		public var hour:int;
		public var min:int;
	}
}
package
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class SocialData extends EventDispatcher
	{
		public var uid:String;
		public var label:String;
		public var icon:String;
		public var selected:Boolean;
	}
}
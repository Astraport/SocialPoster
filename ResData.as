package
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class ResData extends EventDispatcher
	{
		public var uid:String;
		public var name:String;
		public var url:String;
		public var social:int;
		public var tags:String;
		public var mintags:int;
		public var maxtags:int;
		public var minposts:int;
		public var maxposts:int;
		public var selected:Boolean;
	}
}
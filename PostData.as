package
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class PostData extends EventDispatcher {
		public var sort:int;
		public var uid:String;
		public var text:String;
		public var image:String;
		public var url:String;
		public var socials:Vector.<int>;
		public var res:String;
		public var resources:ArrayCollection;
		public var tags:String;
		public var prior:int;
		public var published:Boolean;
	}
}
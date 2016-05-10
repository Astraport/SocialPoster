package
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	public class LoadData extends EventDispatcher
	{
		public var conn:SQLConnection;
		private var selectStmt:SQLStatement;
		
		
		public function start():void
		{
			
			var str:String = "db/social.db";
			var embededSessionDB:File = File.applicationDirectory.resolvePath(str);
			/*var writeSessionDB:File = File.applicationStorageDirectory.resolvePath(str);
			if (!writeSessionDB.exists) {
				embededSessionDB.copyTo(writeSessionDB);
			}
			trace (writeSessionDB.nativePath);*/
			//var dbFile:File = writeSessionDB;
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openSuccess);
			conn.addEventListener(SQLErrorEvent.ERROR, openFailure1);
			conn.openAsync(embededSessionDB);
		}
		
		protected function openFailure1(event:SQLErrorEvent):void
		{
			trace ('0 error ' + event.text);
			conn.removeEventListener(SQLEvent.OPEN, openSuccess);
			conn.removeEventListener(SQLErrorEvent.ERROR, openFailure1);
		}
		
		protected function openSuccess(event:SQLEvent):void
		{
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM socials";
			selectStmt.text = sql;
			selectStmt.addEventListener(SQLEvent.RESULT, selectResult);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, openFailure);
			selectStmt.execute();
		}
		
		protected function selectResult(event:SQLEvent):void
		{
			selectStmt.removeEventListener(SQLEvent.RESULT, selectResult);
			selectStmt.removeEventListener(SQLErrorEvent.ERROR, openFailure);
			var result:SQLResult = selectStmt.getResult();
			if (result.data != null)
			{
				Copypaste.socials = new ArrayCollection();
				
				for (var i:int = 0; i < result.data.length; i++)
				{
					var obj:SocialData= new SocialData();
					obj.uid = result.data[i].uid;
					obj.label = result.data[i].label;
					obj.icon = result.data[i].icon;
					obj.selected = false;
					Copypaste.socials.addItemAt(obj, 0);
				}
			}
			
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM resources";
			selectStmt.text = sql;
			selectStmt.addEventListener(SQLEvent.RESULT, selectResult2);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, selectError);
			selectStmt.execute();
		}
		
		protected function selectResult2(event:SQLEvent):void
		{
			selectStmt.removeEventListener(SQLEvent.RESULT, selectResult2);
			selectStmt.removeEventListener(SQLErrorEvent.ERROR, selectError);
			var result:SQLResult = selectStmt.getResult();
			if (result.data != null)
			{
				Copypaste.resources = new ArrayCollection();
				
				for (var i:int = 0; i < result.data.length; i++)
				{
					var obj:ResData = new ResData ();
					obj.uid = result.data[i].uid;
					obj.name = result.data[i].name;
					obj.url = result.data[i].url;
					obj.social = result.data[i].social;
					obj.tags = result.data[i].tags;
					obj.mintags = result.data[i].mintags;
					obj.maxtags = result.data[i].maxtags;
					obj.minposts = result.data[i].minposts;
					obj.maxposts = result.data[i].maxposts;
					//obj.selected = false;
					Copypaste.resources.addItemAt(obj, 0);
				}
			}
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM option WHERE id = '0'";
			selectStmt.text = sql;
			selectStmt.addEventListener(SQLEvent.RESULT, selectResult5);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, selectError);
			selectStmt.execute();
			
		}
		
		protected function selectResult5(event:SQLEvent):void
		{
			selectStmt.removeEventListener(SQLEvent.RESULT, selectResult5);
			selectStmt.removeEventListener(SQLErrorEvent.ERROR, selectError);
			var result:SQLResult = selectStmt.getResult();
			if (result.data != null)
			{
				Copypaste.planPublish = (result.data[0].planning == 1) ? true : false;
				Copypaste.startMonitor = (result.data[0].monitoring == 1) ? true : false;
			}
			
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM planner";
			selectStmt.text = sql;
			selectStmt.addEventListener(SQLEvent.RESULT, selectResult4);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, selectError);
			selectStmt.execute();
		}
		
		
		protected function selectResult4(event:SQLEvent):void
		{
			selectStmt.removeEventListener(SQLEvent.RESULT, selectResult4);
			selectStmt.removeEventListener(SQLErrorEvent.ERROR, selectError);
			var result:SQLResult = selectStmt.getResult();
			if (result.data != null)
			{
				Copypaste.planner = new ArrayCollection();
				
				for (var i:int = 0; i < result.data.length; i++)
				{
					var obj:PlanData= new PlanData ();
					obj.uid = result.data[i].uid;
					obj.hour = result.data[i].hour;
					obj.min = result.data[i].min;
					Copypaste.planner.addItemAt(obj, 0);
				}
			}
			
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM main";
			selectStmt.text = sql;
			selectStmt.addEventListener(SQLEvent.RESULT, selectResult3);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, selectError);
			selectStmt.execute();
		}
		
		protected function selectResult3(event:SQLEvent):void
		{
			selectStmt.removeEventListener(SQLEvent.RESULT, selectResult3);
			selectStmt.removeEventListener(SQLErrorEvent.ERROR, selectError);
			var result:SQLResult = selectStmt.getResult();
			//trace ('result ' + result.data);
			if (result.data != null)
			{
				Copypaste.posts = new ArrayCollection();
				
				for (var i:int = 0; i < result.data.length; i++)
				{
					var obj:PostData= new PostData();
					obj.sort = result.data[i].sort;
					obj.uid = result.data[i].uid;
					obj.text = result.data[i].text;
					obj.image = result.data[i].image;
					obj.url = result.data[i].url;
					obj.socials = Vector.<int>(String(result.data[i].socials).split(","));
					obj.res = result.data[i].res;
					obj.resources = Copypaste.resources;
					obj.tags = result.data[i].tags;
					obj.published = true;
					Copypaste.posts.addItemAt(obj, 0);
					Copypaste.socSelected.push(Copypaste.socials);
				}
			}
			var arr:Array = ["fb","fb","vk","ins","gp","tw","ok","jj","mm","wp","li","rd","yh","ev","ic","ms","pi","vm","de"];
			for (var j:int = 0; j < arr.length; j++) 
			{
				var icondata:IconData = new IconData();
				icondata.icon = arr[j] + ".png";
				icondata.path = "images/socialicons/" + icondata.icon;
				Copypaste.socialIcons.addItem(icondata);
			}
			
			dispatchEvent(new Event("complete"));
		}
		
		
			
		protected function selectError(event:SQLErrorEvent):void
		{
			trace ('2 error ' + event.text);
		}
		
		protected function openFailure(event:SQLErrorEvent):void
		{
			trace ('1 error ' + event.text);
			conn.removeEventListener(SQLEvent.OPEN, openSuccess);
			conn.removeEventListener(SQLErrorEvent.ERROR, openFailure);
		}
	}
}
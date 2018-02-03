package
{
	import com.hxgd.cfg.ConfigParse;
	import com.hxgd.cfg.ConfigTest;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	
	public class load_main extends Sprite
	{
		public function load_main()
		{
			m_ConfigFile.addEventListener(Event.SELECT, OnFileSelect);
			m_ConfigFile.addEventListener(Event.COMPLETE,OnFileLoadComplete);
			var stFileter:FileFilter = new FileFilter("配置文件(*.ini)","*.ini");
			m_ConfigFile.browse([stFileter]);	
			m_ConfigParse.OnConfigChange = OnConfigChange;
			m_ConfigParse.OnFieldLoad = OnFieldLoad;
			m_ConfigParse.OnLoadRecord = OnRecordLoad;
			var p:Number = 100;
			var k:Object = 100;
			if (p == k)
			{
				trace("true");	
			}
			else trace("truefalse");	
			
		}
		
		private function OnConfigChange(paramConfigName:String):void
		{
			trace("OnConfigChange:" + paramConfigName);
		}

		private function OnFieldLoad(paramFieldList:Array):void
		{
			for (var i:int = 0; i < paramFieldList.length; i++) 
			{
				trace("Field["+i+"]:"+paramFieldList[i]);
			}
		}
		
		private function OnRecordLoad(paramRecord:Array):void
		{
			trace("Record:");
			for (var i:int = 0; i < paramRecord.length; i++) 
			{
				trace("    F:" + typeof(paramRecord[i]) +" value=" + paramRecord[i]);
			}
			//var t:ConfigTest = new ConfigTest();
			//t.DoLoad(paramRecord);
			//t.p();
		}
		
		protected function OnFileLoadComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			m_ConfigParse.ParseConfig(m_ConfigFile.data);	
				
		}
		
		protected function OnFileSelect(event:Event):void
		{
			m_ConfigFile.load();	
		}
		
		private var m_ConfigFile:FileReference = new FileReference();
		private var m_ConfigParse:ConfigParse = new ConfigParse();
		
	}
}
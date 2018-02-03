package com.hxgd.cfg
{
	public class ConfigTest extends ConfigBase
	{
		public function ConfigTest()
		{
			super();
		}
		
		override public function DoLoad(paramRecord:Array):void
		{
			Field4 = paramRecord[0];
			Field3 = paramRecord[1];
			Field2 = paramRecord[2];
			Field1 = paramRecord[3];
		}
		
		public var Field4:Array=[];
		public var Field3:Array=[];
		public var Field2:Number;
		public var Field1:String;
	}
}

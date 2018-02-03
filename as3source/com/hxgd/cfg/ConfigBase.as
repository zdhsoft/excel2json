package com.hxgd.cfg
{
	/**
	 * 配置类的基类
	 * 要求重载子类DoLoad方法
	 */
	public class ConfigBase
	{
		public function ConfigBase()
		{
		}
		
		public function DoLoad(paramRecord:Array):void
		{
			throw Error("please override this function!");
		}
	}
}
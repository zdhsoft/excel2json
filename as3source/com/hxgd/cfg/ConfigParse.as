package com.hxgd.cfg
{
	import flash.utils.ByteArray;
	import mx.utils.StringUtil;
	/**
	 * 配置文件解析类
	 */
	public class ConfigParse
	{
		private static const LINE_RECORD:int = 0;		///<行是记录数据
		private static const LINE_FIELD:int  = 1;		///<行是字段定义
		private static const LINE_CLASS:int  = 2;		///<行是类定义
		private static const LINE_UNKONW:int = 3;		///<行是未知定义
		private static const PARSE_STATUS_INIT:int = 0; ///<解析开始状态
		private static const PARSE_STATUS_STRING_START:int = 1; ///<字符串开始
		private static const PARSE_STATUS_ARRAY_START:int  = 2;  ///<数组开始
		private static const PARSE_STATUS_OTHER_START:int  = 3;
		private static const PARSE_STATUS_WAIT_SPLIT:int = 4;
		
		public function ConfigParse()
		{
		}
		
		/**
		 * 解析Config
		 * @param [in] paramData 要解析的数据
		 */
		public function ParseConfig(paramData:ByteArray):int
		{
			var strData:String = paramData.readUTFBytes(paramData.bytesAvailable);
			var stLines:Array = strData.split("\n");
			for (var i:int = 0; i < stLines.length; i++) 
			{
				//trace("" + i+1 + ":" + strLines[i]);
				var strLine:String = StringUtil.trim(stLines[i]);
				if (strLine.length == 0) 
				{
					continue;
				}
			    var stResult:Array = ParseLine(strLine);
				if (stResult.length > 0)
				{
					var iType:int = stResult[0];
					stResult.shift();
					switch(iType)
					{
					case LINE_RECORD:
						var R:Array = MakeRecord(stResult);
						//trace(R);
						if (this.m_OnLoadRecord != null)
						{
							m_OnLoadRecord(R);
						}
						break;
					case LINE_FIELD:
						if (m_OnFieldLoad != null)
						{
							m_OnFieldLoad(stResult);
						}
						break;
					case LINE_CLASS:
						if(m_OnConfigChange != null)
						{
							m_OnConfigChange(stResult);
						}
						break;
					}
				}
				//trace(stResult);
			}
			return 0;
		}
		/**
		 * 将解析后的字段值列表，生成记录 
		 */
		private function MakeRecord(paramFields:Array):Array
		{
			var stRet:Array = [];
			for(var i:int = 0; i < paramFields.length; i++)
			{
				var stField:String = paramFields[i];
				var stFirst:String = stField.charAt(0);
				if (stFirst == "\"")
				{
					stRet.push(MakeStringField(stField));
				}
				else if (stFirst == "[")
				{
					stRet.push(MakeArrayField(stField));
				}
				else 
				{
					stRet.push(MakeNumberField(stField));
				}
			}
			return stRet;
		}
		/**
		 * 解析一行
		 * 返回的第一个字段是类型
		 */
		private function ParseLine(paramLine:String):Array
		{
			var stRetFieldList:Array = [LINE_UNKONW];
			do
			{
				if (paramLine.length == 0)
				{
					break;
				}
				var strFirst:String = paramLine.charAt(0);
				var strLast:String;
				var strTemp:String;
				
				if(strFirst == "[")  //如果是类型名称
				{
					strLast = paramLine.charAt(paramLine.length - 1);
					if (strLast != "]" || paramLine.length < 3)
					{
						break;
					}
					var strClassName:String = StringUtil.trim(paramLine.substr(1, paramLine.length -2));
					if (strClassName.length == 0)
					{
						break;
					}
					stRetFieldList[0] = LINE_CLASS;
					stRetFieldList.push(strClassName);
				}
				else if(strFirst == "<") //如果是字段名名称列表
				{
					strLast = paramLine.charAt(paramLine.length - 1);
					if (strLast != ">" || paramLine.length < 3)
					{
						break;
					}
					var strFields:String = StringUtil.trim(paramLine.substr(1, paramLine.length -2));
					if (strFields.length == 0)
					{
						break;
					}
					var stList:Array = strFields.split(",");
					if (stList.length == 0)
					{
						break;
					}
					var boolErrorFlag:Boolean = false;
					for (var i:int = 0; i < stList.length; i++) 
					{
						strTemp = StringUtil.trim(stList[i]);
						if (strTemp.length == 0)
						{
							boolErrorFlag = true;
							break;
						}
						stList[i] = strTemp;
					}
					if (boolErrorFlag)
					{
						break;	
					}
					stRetFieldList[0] = LINE_FIELD;
					
					for (var j:int = 0; j < stList.length; j++) 
					{
						stRetFieldList.push(stList[j]);
					}
				}
				else if(strFirst == "#") //如果是记录
				{
					if (paramLine.length < 2)
					{
						break;
					}
					strTemp = StringUtil.trim(paramLine.substr(1, paramLine.length - 1));
					if(strTemp.length == 0)
					{
						break;
					}
					var stParseFieldList:Array = ParseFieldLine(strTemp);
					//trace(stParseFieldList);
					for (var k:int = 0; k < stParseFieldList.length; k++) 
					{
						stRetFieldList.push(stParseFieldList[k]);
					}
					stRetFieldList[0] = LINE_RECORD;
				}
				else   //如果不是指定的合法格式
				{
					break;
				}
			}
			while(false);
			return stRetFieldList;
		}
		/**
		 * 生成字符串类型的字段值
		 */
		private function MakeStringField(paramField:String):String
		{
			if(paramField.length > 2)
			{
				return paramField.substr(1,paramField.length -2);
			}
			else
			{
				return "";
			}
		}
		/**
		 * 生成数字类型的字段值
		 */
		private function MakeNumberField(paramField:String):Number
		{
			return parseFloat(paramField);
		}
		/**
		 * 生成数组类型的字段值
		 */
		private function MakeArrayField(paramField:String):Array
		{
			var stRet:Array = [];
			if (paramField.length > 2)
			{
				var stParseArray:Array = ParseFieldLine(paramField.substr(1,paramField.length-2));
				stRet = MakeRecord(stParseArray);
			}
			return stRet;
		}
		/**
		 * 解析字段列表
		 */
		private function ParseFieldLine(paramFieldContent:String):Array
		{
			var stRetField:Array = [];
			var strTemp:String = "";
			var strChar:String = "";
			var strContent:String = "";
			var iCloseCount:int = 0;	///< 字符[的个数
			var iStatus:int = PARSE_STATUS_INIT;
			for(var i:int = 0; i < paramFieldContent.length; i++)
			{
				strChar = paramFieldContent.charAt(i);
				switch(iStatus)
				{
				case PARSE_STATUS_INIT:  //如果是初始状态
					strTemp = StringUtil.trim(strChar);
					if(strTemp.length == 0) //如果是空串字符
					{
						break;
					}
					if (strTemp == "\"")   //如果是字符串
					{
						iStatus = PARSE_STATUS_STRING_START;
						strContent = strTemp;
					}
					else if (strTemp == "[") //如果是数组
					{
						iStatus = PARSE_STATUS_ARRAY_START;
						strContent = strTemp;
					}
					else if (strTemp == ",")  //如果没任何内容 
					{
						break;
					}
					else
					{
						iStatus = PARSE_STATUS_OTHER_START;  //如果是数字类,这里默认视为数字
						strContent = strTemp;
					}
					break;
				case PARSE_STATUS_STRING_START:
					strTemp = strChar;
					if (strTemp == "\"")
					{
						iStatus = PARSE_STATUS_WAIT_SPLIT;
						strContent += strTemp;
						stRetField.push(strContent);
						strContent = "";
					}
					else
					{
						strContent += strTemp;
					}
					break;
				case PARSE_STATUS_ARRAY_START:
					strTemp = strChar;
					if (strTemp == "]")
					{
						if (iCloseCount > 0)
						{
							strContent += strTemp;
							iCloseCount --;
						}
						else
						{
							iStatus = PARSE_STATUS_WAIT_SPLIT;	
							strContent += strTemp;
							stRetField.push(strContent);
							strContent = "";
						}
					}
					else
					{
						if (strTemp == "[")
						{
							iCloseCount ++;	
						}
						strContent += strTemp;
					}
					break;
				case PARSE_STATUS_OTHER_START:
					strTemp = strChar;
					if (strTemp == ",")
					{
						iStatus = PARSE_STATUS_INIT;
						stRetField.push(strContent);
						strContent = "";
					}
					else
					{
						strContent += strTemp;						
					}
					break;
				case PARSE_STATUS_WAIT_SPLIT:
					strTemp = strChar;
					if (strTemp == ",")
					{
						iStatus = PARSE_STATUS_INIT;
						strContent = "";
					}
					break;
				}
			}
			if (strContent.length > 0)
			{
				stRetField.push(strContent);
				strContent = "";
			}			
			return stRetField;
		}
		
		//下面是一组回调函数属性
		//------------------------------------
		//property OnConfigChange
		private var m_OnConfigChange:Function;
		public function get OnConfigChange():Function 
		{ 
			return m_OnConfigChange; 
		}
		
		public function set OnConfigChange(value:Function):void
		{
			if (m_OnConfigChange == value)
				return;
			m_OnConfigChange = value;
		}
		
		//------------------------------------
		//property OnLoadRecord
		private var m_OnLoadRecord:Function;
		public function get OnLoadRecord():Function 
		{ 
			return m_OnLoadRecord; 
		}
		
		public function set OnLoadRecord(value:Function):void
		{
			if (m_OnLoadRecord == value)
				return;
			m_OnLoadRecord = value;
		}
		
		//------------------------------------
		//property OnFieldLoad
		private var m_OnFieldLoad:Function;
		public function get OnFieldLoad():Function 
		{ 
			return m_OnFieldLoad; 
		}
		
		public function set OnFieldLoad(value:Function):void
		{
			if (m_OnFieldLoad == value)
				return;
			m_OnFieldLoad = value;
		}
	}
}
package com.hxgd.cfg
{
    public class School extends ConfigBase
    {
        public function School()
        {
            super();
        }

        public static var List:Array = [];

        public static function AddRecord(paramRecord:Array):void
        {
            var r:School = new School();
            r.DoLoad(paramRecord);
            List.push(r);
        }

        public static function GetBy_ID(paramKey:*):School
        {
            for each (var record:School in List)
            {
                if (record.ID == paramKey)
                {
                    return record;
                }
            }
            return null;
        }

        override public function DoLoad(paramRecord:Array):void
        {
            ID = paramRecord[0];
            Size = paramRecord[1];
            BlockSize = paramRecord[2];
            InitBlock = paramRecord[3];
            Map = paramRecord[4];
        }

        public var ID:Number;
        public var Size:Array=[];
        public var BlockSize:Array=[];
        public var InitBlock:Array=[];
        public var Map:String;
    }
}

package com.hxgd.cfg
{
    public class Level extends ConfigBase
    {
        public function Level()
        {
            super();
        }

        public static var List:Array = [];

        public static function AddRecord(paramRecord:Array):void
        {
            var r:Level = new Level();
            r.DoLoad(paramRecord);
            List.push(r);
        }

        public static function GetBy_Level(paramKey:*):Level
        {
            for each (var record:Level in List)
            {
                if (record.Level == paramKey)
                {
                    return record;
                }
            }
            return null;
        }

        override public function DoLoad(paramRecord:Array):void
        {
            Level = paramRecord[0];
            Exp = paramRecord[1];
            ExpStart = paramRecord[2];
            ExpEnd = paramRecord[3];
        }

        public var Level:Number;
        public var Exp:Number;
        public var ExpStart:Number;
        public var ExpEnd:Number;
    }
}

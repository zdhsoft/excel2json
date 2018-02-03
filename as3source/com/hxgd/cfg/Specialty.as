package com.hxgd.cfg
{
    public class Specialty extends ConfigBase
    {
        public function Specialty()
        {
            super();
        }

        public static var List:Array = [];

        public static function AddRecord(paramRecord:Array):void
        {
            var r:Specialty = new Specialty();
            r.DoLoad(paramRecord);
            List.push(r);
        }

        public static function GetBy_ID(paramKey:*):Specialty
        {
            for each (var record:Specialty in List)
            {
                if (record.ID == paramKey)
                {
                    return record;
                }
            }
            return null;
        }

        public static function GetBy_Name(paramKey:*):Specialty
        {
            for each (var record:Specialty in List)
            {
                if (record.Name == paramKey)
                {
                    return record;
                }
            }
            return null;
        }

        override public function DoLoad(paramRecord:Array):void
        {
            ID = paramRecord[0];
            Name = paramRecord[1];
            Open = paramRecord[2];
        }

        public var ID:Number;
        public var Name:String;
        public var Open:Number;
    }
}

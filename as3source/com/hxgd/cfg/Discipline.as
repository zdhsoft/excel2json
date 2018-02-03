package com.hxgd.cfg
{
    public class Discipline extends ConfigBase
    {
        public function Discipline()
        {
            super();
        }

        public static var List:Array = [];

        public static function AddRecord(paramRecord:Array):void
        {
            var r:Discipline = new Discipline();
            r.DoLoad(paramRecord);
            List.push(r);
        }

        public static function GetBy_ID(paramKey:*):Discipline
        {
            for each (var record:Discipline in List)
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
            Discipline = paramRecord[1];
            SpecialtyID = paramRecord[2];
            Lever = paramRecord[3];
            Experience = paramRecord[4];
        }

        public var ID:Number;
        public var Discipline:String;
        public var SpecialtyID:Number;
        public var Lever:Number;
        public var Experience:Number;
    }
}

package com.hxgd.cfg
{
    public class Props extends ConfigBase
    {
        public function Props()
        {
            super();
        }

        public static var List:Array = [];

        public static function AddRecord(paramRecord:Array):void
        {
            var r:Props = new Props();
            r.DoLoad(paramRecord);
            List.push(r);
        }

        public static function GetBy_ID(paramKey:*):Props
        {
            for each (var record:Props in List)
            {
                if (record.ID == paramKey)
                {
                    return record;
                }
            }
            return null;
        }

        public static function GetBy_Name(paramKey:*):Props
        {
            for each (var record:Props in List)
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
            Desc = paramRecord[2];
            FaceType = paramRecord[3];
            UseArea = paramRecord[4];
            BuyPrice = paramRecord[5];
            SalePrice = paramRecord[6];
            StackFlag = paramRecord[7];
            StackCount = paramRecord[8];
            Valid = paramRecord[9];
        }

        public var ID:Number;
        public var Name:String;
        public var Desc:String;
        public var FaceType:Number;
        public var UseArea:Number;
        public var BuyPrice:Number;
        public var SalePrice:Number;
        public var StackFlag:Number;
        public var StackCount:Number;
        public var Valid:Number;
    }
}

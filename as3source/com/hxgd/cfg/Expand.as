package com.hxgd.cfg
{
    public class Expand extends ConfigBase
    {
        public function Expand()
        {
            super();
        }

        public static var List:Array = [];

        public static function AddRecord(paramRecord:Array):void
        {
            var r:Expand = new Expand();
            r.DoLoad(paramRecord);
            List.push(r);
        }

        public static function GetBy_Quantity(paramKey:*):Expand
        {
            for each (var record:Expand in List)
            {
                if (record.Quantity == paramKey)
                {
                    return record;
                }
            }
            return null;
        }

        override public function DoLoad(paramRecord:Array):void
        {
            Quantity = paramRecord[0];
            LockLevel = paramRecord[1];
            LicQuantity = paramRecord[2];
            GoldCoin = paramRecord[3];
            BuyMoney = paramRecord[4];
        }

        public var Quantity:Number;
        public var LockLevel:Number;
        public var LicQuantity:Number;
        public var GoldCoin:Number;
        public var BuyMoney:Number;
    }
}

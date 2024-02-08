tableextension 50051 SaleLine extends "Sales Line"
{
    fields
    {
        field(50000; "TCS Nature of Collection 1"; Code[10])
        {
            DataClassification = CustomerContent;


        }
        field(50002; "GST Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}
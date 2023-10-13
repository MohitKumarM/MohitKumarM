tableextension 50052 PurchaseCrLine extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50000; "P.A.N. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
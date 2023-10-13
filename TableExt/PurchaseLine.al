tableextension 50050 PurchaseLine extends "Purchase Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                VendorR: Record Vendor;
            begin
                IF (Type = Type::"Charge (Item)") or (Type = Type::Item) or (Type = Type::"G/L Account") THEN begin
                    IF VendorR.GET("Pay-to Vendor No.") THEN
                        "P.A.N. No." := VendorR."P.A.N. No.";
                end;
            end;
        }
        field(50000; "P.A.N. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
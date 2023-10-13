pageextension 50005 "Posted Sales Invoices" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Bill-to")
        {
            field("TC_E-Way bill"; Rec."TC_E-Way bill")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }

    actions
    {

        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
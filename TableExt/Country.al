tableextension 50055 Country extends "Country/Region"
{
    fields
    {
        field(50050; "Country Code for E Invoicing"; Code[2])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
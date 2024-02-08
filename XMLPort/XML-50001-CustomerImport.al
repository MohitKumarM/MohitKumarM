xmlport 50001 "Customer Upload 2"
{
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF16;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Import_Customer; Customer)
            {
                fieldelement(CustomerName; Import_Customer.Name)
                {
                    FieldValidate = Yes;
                }
                fieldelement(CustomerName2; Import_Customer."Name 2")
                {
                    FieldValidate = Yes;
                }
                fieldelement(CustomerAddress; Import_Customer.Address)
                {
                    FieldValidate = Yes;
                }
                fieldelement(CustomerAddress2; Import_Customer."Address 2")
                {
                    FieldValidate = Yes;
                }

                fieldelement(CustomerPhone; Import_Customer."Mobile Phone No.")
                {
                    FieldValidate = Yes;
                }

                trigger OnAfterInitRecord()
                var
                    myInt: Integer;
                    SalesRecivalbeSetup: Record "Sales & Receivables Setup";
                    CustomerNo: Code[20];
                    NoSeriesmMang: Codeunit 396;
                begin
                    IF SKipFirstRow THEN begin
                        SKipFirstRow := FALSE;
                        currXMLport.SKIP;
                    end;
                    SalesRecivalbeSetup.GET;
                    Import_Customer."No." := NoSeriesmMang.GetNextNo(SalesRecivalbeSetup."Customer Nos.", TODAY, TRUE);
                end;
            }
        }
    }
    trigger OnInitXmlPort()
    var

    begin
        SkipFirstRow := true;
    end;

    trigger OnPostXmlPort()
    var
        myInt: Integer;
    begin
        Message('Import Successfully');
    end;


    var
        SkipFirstRow: Boolean;
}
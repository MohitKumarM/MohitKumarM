xmlport 50000 "Customer Upload"
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
                AutoSave = false;

                textelement(CustomerName)
                {
                    MinOccurs = Zero;
                }
                textelement(CustomerName2)
                {
                    MinOccurs = Zero;
                }
                textelement(CustomerAddress)
                {
                    MinOccurs = Zero;
                }
                textelement(CustomerAddress2)
                {
                    MinOccurs = Zero;
                }
                textelement(customerPhoneNo)
                {
                    MinOccurs = Zero;
                }


                trigger OnAfterInitRecord()
                var
                    SalesRecivalbeSetup: Record "Sales & Receivables Setup";
                    CustomerNo: Code[20];
                    NoSeriesmMang: Codeunit NoSeriesManagement;
                    CustomerImport: Record Customer;
                    CustomerImort2: Record Customer;
                begin
                    IF SKipFirstRow THEN begin
                        SKipFirstRow := FALSE;
                        currXMLport.SKIP;
                    end;
                    SalesRecivalbeSetup.GET;
                    CustomerNo := NoSeriesmMang.GetNextNo(SalesRecivalbeSetup."Customer Nos.", TODAY, TRUE);
                    if not CustomerImport.get(CustomerNo) then begin
                        CustomerImort2.Init();
                        CustomerImort2."No." := CustomerNo;
                        CustomerImort2.Validate(Name, CustomerName);
                        CustomerImort2.Validate("Name 2", CustomerName2);
                        CustomerImort2.Validate(Address, CustomerAddress);
                        CustomerImort2.Validate("Address 2", CustomerAddress2);
                        CustomerImort2.Validate("Mobile Phone No.", CustomerPhoneNo);
                        CustomerImort2.Insert(true);
                    end;
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
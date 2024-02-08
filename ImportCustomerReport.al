report 50032 "Import Sales Invoice"
{
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ImportOption; ImportOption)
                    {
                        Caption = 'Option';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            IF CloseAction = ACTION::OK THEN BEGIN
                UploadIntoStream(Text006, '', '', ServerFileName, Instr);
                IF ServerFileName = '' THEN
                    EXIT(FALSE)
                else begin
                    FileName := FileMgt.GetFileName(ServerFileName);
                    SheetName := ExcelBuf.SelectSheetsNameStream(Instr);
                end;
                IF SheetName = '' THEN
                    EXIT(FALSE);
            END;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF ImportOption = ImportOption::"Replace entries" THEN
            ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBookStream(Instr, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        ExcelBuf.DELETEALL;

        MESSAGE('Import Completed.');
    end;

    var
        ImportOption: Option "Add entries","Replace entries";
        ServerFileName: Text;
        SheetName: Text[250];
        FileMgt: Codeunit "File Management";
        ExcelBuf: Record "Excel Buffer";
        X: Integer;
        TotalColumns: Integer;
        TotalRows: Integer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagment: Codeunit NoSeriesManagement;
        Text006: Label 'Import Excel File';

        CustomerL: Record Customer;
        Instr: InStream;
        FileName: Text;

    procedure GetLastRowandColumn()
    begin
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    end;

    procedure InsertData(RowNo: Integer)
    var
        Customer: Record Customer;
        No: Code[20];
    begin
        SalesReceivablesSetup.GET;
        No := NoSeriesManagment.GetNextNo(SalesReceivablesSetup."Customer Nos.", WORKDATE, TRUE);
        if not Customer.get(No) then begin
            CustomerL.Init();
            CustomerL."No." := No;

            CustomerL.VALIDATE(CustomerL.Name, GetValueAtCell(RowNo, 1));

            CustomerL.Validate(CustomerL."Name 2", GetValueAtCell(RowNo, 2));

            CustomerL.Validate(CustomerL.Address, GetValueAtCell(RowNo, 3));

            CustomerL.Validate(CustomerL."Address 2", GetValueAtCell(RowNo, 4));

            CustomerL.Validate(CustomerL."Mobile Phone No.", GetValueAtCell(RowNo, 5));
            CustomerL.Insert();
        end;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        if ExcelBuf1.GET(RowNo, ColNo) then
            EXIT(ExcelBuf1."Cell Value as Text");
    end;
}

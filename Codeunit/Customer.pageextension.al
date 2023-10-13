pageextension 50001 CustomerListext extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Customer")
        {
            action("TestAuth20")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Auth20: Codeunit 50000;
                begin
                    Auth20.Run();
                end;
            }
            action(Test_DownloadReport)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    TestReport: Report 402;
                    Purchaseheader: Record 38;
                    OutStrm: OutStream;
                    FileName: Text;
                    Tempblob: Codeunit "Temp Blob";
                    Instrm: InStream;
                begin
                    Purchaseheader.SetRange("Document Type", Purchaseheader."Document Type"::Invoice);
                    Purchaseheader.SetRange("No.", '108017');
                    if Purchaseheader.FindFirst() then;
                    TestReport.SetTableView(Purchaseheader);
                    Tempblob.CreateOutStream(OutStrm);
                    TestReport.SaveAs('', ReportFormat::Pdf, OutStrm);
                    Tempblob.CreateInStream(Instrm);
                    FileName := 'TestDownload.pdf';
                    DownloadFromStream(Instrm, '', '', '', FileName);
                end;
            }
        }
    }
}
pageextension 50122 DocumentAttachmentDetailsExt extends "Document Attachment Details"
{
    actions
    {
        addafter(Preview)
        {
            action("PDFV View PDF")
            {
                ApplicationArea = All;
                Image = Text;
                Caption = 'View PDF';
                ToolTip = 'View PDF';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Enabled = Rec."File Extension" = 'pdf';
                trigger OnAction()
                var
                    PDFViewerDocAttachment: Page "PDFV PDFViewerDocAttachament";
                begin
                    PDFViewerDocAttachment.SetRecord(Rec);
                    PDFViewerDocAttachment.SetTableView(Rec);
                    PDFViewerDocAttachment.Run();
                end;
            }
            action(BulkDownload)
            {
                Caption = 'Bulk Download';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileManagement: Codeunit "File Management";
                    DocumentOutStream: OutStream;
                    DocumentInStream: InStream;
                    ZipOutStream: OutStream;
                    ZipInStream: InStream;
                    FullFileName: Text;
                    DataCompression: Codeunit "Data Compression";
                    ZipFileName: Text[50];
                    DocumentAttachment: Record "Document Attachment";
                begin
                    ZipFileName := 'Attachments_' + Format(CurrentDateTime) + '.zip';
                    DataCompression.CreateZipArchive();
                    DocumentAttachment.Reset();
                    CurrPage.SetSelectionFilter(DocumentAttachment);
                    if DocumentAttachment.FindSet() then
                        repeat
                            if DocumentAttachment."Document Reference ID".HasValue then begin
                                TempBlob.CreateOutStream(DocumentOutStream);
                                DocumentAttachment."Document Reference ID".ExportStream(DocumentOutStream);
                                TempBlob.CreateInStream(DocumentInStream);
                                FullFileName := DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension";
                                DataCompression.AddEntry(DocumentInStream, FullFileName);
                            end;
                        until DocumentAttachment.Next() = 0;
                    TempBlob.CreateOutStream(ZipOutStream);
                    DataCompression.SaveZipArchive(ZipOutStream);
                    TempBlob.CreateInStream(ZipInStream);
                    DownloadFromStream(ZipInStream, '', '', '', ZipFileName);
                end;
            }
        }
    }
}
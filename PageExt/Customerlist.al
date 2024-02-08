// pageextension 50105 CustomerListExt extends "Customer List"
// {
//     actions
//     {
//         addfirst(processing)
//         {
//             action(RunHyperLink)
//             {
//                 Caption = 'Run HyperLink';
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 PromotedCategory = Process;
//                 trigger OnAction()
//                 begin
//                     //Hyperlink('https://yzhums.com/');
//                     Hyperlink('file:///C:/Users/15800/Downloads/document%20(19).pdf');
//                 end;
//             }
//             action(RunHyperLinkInBC)
//             {
//                 Caption = 'Run HyperLink in BC';
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedIsBig = true;
//                 PromotedCategory = Process;
//                 trigger OnAction()
//                 var
//                     ZYHyperLink: Page "ZY HyperLink";
//                 begin
//                     //ZYHyperLink.SetURL('https://yzhums.com/');
//                     Message(GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Customer List"));
//                     ZYHyperLink.SetURL(GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Customer List"));

//                     ZYHyperLink.Run();

//                 end;
//             }
//         }
//         addafter("&Customer")
//         {
//             action("Customer Import")
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     CustomerImport: XmlPort "Customer Upload";
//                 begin
//                     Clear(CustomerImport);
//                     CustomerImport.Run();
//                 end;
//             }
//             action("Customer Import 2")
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     CustomerImport: XmlPort "Customer Upload 2";
//                 begin
//                     Clear(CustomerImport);
//                     CustomerImport.Run();
//                 end;
//             }
//             action("Customer Import 3")
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     auth: Codeunit "Auth 2.0";
//                 begin
//                     auth.IffcoMCAuth();
//                 end;
//             }
//             action("TestAuth20")
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     Auth20: Codeunit 50000;
//                 begin
//                     Auth20.Run();
//                 end;
//             }
//             action(Test_DownloadReport)
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     TestReport: Report 402;
//                     Purchaseheader: Record 38;
//                     OutStrm: OutStream;
//                     FileName: Text;
//                     Tempblob: Codeunit "Temp Blob";
//                     Instrm: InStream;
//                 begin
//                     Purchaseheader.SetRange("Document Type", Purchaseheader."Document Type"::Invoice);
//                     Purchaseheader.SetRange("No.", '108017');
//                     if Purchaseheader.FindFirst() then;
//                     TestReport.SetTableView(Purchaseheader);
//                     Tempblob.CreateOutStream(OutStrm);
//                     TestReport.SaveAs('', ReportFormat::Pdf, OutStrm);
//                     Tempblob.CreateInStream(Instrm);
//                     FileName := 'TestDownload.pdf';
//                     DownloadFromStream(Instrm, '', '', '', FileName);
//                 end;
//             }
//         }
//         addafter("Sent Emails")
//         {
//             action(ImportZipFile)
//             {
//                 Caption = 'Import Zip File';
//                 ApplicationArea = All;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Image = Import;
//                 ToolTip = 'Import Attachments from Zip';

//                 trigger OnAction()
//                 begin
//                     ImportAttachmentsFromZip();
//                 end;
//             }
//         }

//     }
//     local procedure ImportAttachmentsFromZip()
//     var
//         FileMgt: Codeunit "File Management";
//         DataCompression: Codeunit "Data Compression";
//         TempBlob: Codeunit "Temp Blob";
//         EntryList: List of [Text];
//         EntryListKey: Text;
//         ZipFileName: Text;
//         FileName: Text;
//         FileExtension: Text;
//         InStream: InStream;
//         EntryOutStream: OutStream;
//         EntryInStream: InStream;
//         Length: Integer;
//         SelectZIPFileMsg: Label 'Select ZIP File';
//         FileCount: Integer;
//         Cust: Record Customer;
//         DocAttach: Record "Document Attachment";
//         NoCustError: Label 'Customer %1 does not exist.';
//         ImportedMsg: Label '%1 attachments Imported successfully.';
//     begin
//         //Upload zip file
//         if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
//             Error('');

//         //Extract zip file and store files to list type
//         DataCompression.OpenZipArchive(InStream, false);
//         DataCompression.GetEntryList(EntryList);

//         FileCount := 0;

//         //Loop files from the list type
//         foreach EntryListKey in EntryList do begin
//             FileName := CopyStr(FileMgt.GetFileNameWithoutExtension(EntryListKey), 1, MaxStrLen(FileName));
//             FileExtension := CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen(FileExtension));
//             TempBlob.CreateOutStream(EntryOutStream);
//             DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
//             TempBlob.CreateInStream(EntryInStream);

//             //Import each file where you want
//             if not Cust.Get(FileName) then
//                 Error(NoCustError, FileName);
//             DocAttach.Init();
//             DocAttach.Validate("Table ID", Database::Customer);
//             DocAttach.Validate("No.", FileName);
//             DocAttach.Validate("File Name", FileName);
//             DocAttach.Validate("File Extension", FileExtension);
//             DocAttach."Document Reference ID".ImportStream(EntryInStream, FileName);
//             DocAttach.Insert(true);
//             FileCount += 1;
//         end;

//         //Close the zip file
//         DataCompression.CloseZipArchive();

//         if FileCount > 0 then
//             Message(ImportedMsg, FileCount);
//     end;

// }

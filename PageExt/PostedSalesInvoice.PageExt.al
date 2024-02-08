// pageextension 50005 "Posted Sales Invoices" extends "Posted Sales Invoice"
// {
//     layout
//     {
//         addafter("Bill-to")
//         {
//             field("TC_E-Way bill"; Rec."TC_E-Way bill")
//             {
//                 ApplicationArea = all;
//                 Editable = true;
//             }
//         }
//     }

//     actions
//     {

//         addafter("&Invoice")
//         {
//             action(TestJsonPayload)
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
//                 trigger OnAction()
//                 var
//                     EInvoiceGeneration: Codeunit 50051;
//                 begin
//                     Clear(EInvoiceGeneration);
//                     EInvoiceGeneration.GenerateIRN(Rec."No.", 1);
//                 end;
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }
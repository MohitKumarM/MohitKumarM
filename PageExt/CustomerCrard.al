// pageextension 50050 CustomerCard extends "Customer Card"
// {
//     layout
//     {
//         addafter(Address)
//         {
//             field("Skip Tcs"; Rec."Skip Tcs")
//             {
//                 ApplicationArea = all;
//             }
//         }
//     }

//     actions
//     {

//         addafter("&Customer")
//         {
//             action("Customer Import")
//             {
//                 ApplicationArea = All;
//                 Promoted = true;
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
//                 trigger OnAction()
//                 var
//                     CustomerImport: XmlPort "Customer Upload 2";
//                 begin

//                     CustomerImport.Run();
//                 end;
//             }
//         }
//     }

//     var
//         SkipTcs: Boolean;

//     trigger OnAfterGetCurrRecord()
//     var
//         myInt: Integer;
//     begin
//         if Rec."Skip Tcs" then
//             SkipTcs := false
//         else
//             SkipTcs := true;
//     end;
// }
// codeunit 50051 "E-Invoice Generation"
// { // Need To Assgin Round Gl Value
//     trigger OnRun()
//     begin
//     end;

//     procedure GenerateIRN(DocumentNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment")
//     var
//         LDetailedGSTLedgInfo: Record "Detailed GST Ledger Entry Info";
//         LDetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
//         JsonPayloalObject: JsonObject;
//         JsonPayload: Text;
//         GLAccountRound1: Code[20];
//         GlAccountRound2: Code[20];
//         Currencyfactor: Decimal;
//         SalesInvoiceHeader: Record "Sales Invoice Header";
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//     begin
//         Currencyfactor := 1;
//         LDetailedGSTLedgerEntry.Reset();
//         LDetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
//         if not LDetailedGSTLedgerEntry.FindFirst() then
//             exit;
//         if LDetailedGSTLedgInfo.Get(LDetailedGSTLedgerEntry."Entry No.") then;
//         LDetailedGSTLedgInfo.SetRange("Original Doc. Type", DocumentType);
//         if not LDetailedGSTLedgInfo.FindFirst() then
//             exit;
//         case
//             DocumentType of
//             DocumentType::Invoice:
//                 begin
//                     if SalesInvoiceHeader.get(DocumentNo) then begin
//                         if SalesInvoiceHeader."Currency Factor" <> 0 then
//                             Currencyfactor := SalesInvoiceHeader."Currency Factor"
//                         else
//                             Currencyfactor := 1;
//                     end;
//                 end;
//             DocumentType::"Credit Memo":
//                 begin
//                     if SalesCrMemoHeader.get(DocumentNo) then begin
//                         if SalesCrMemoHeader."Currency Factor" <> 0 then
//                             Currencyfactor := SalesCrMemoHeader."Currency Factor"
//                         else
//                             Currencyfactor := 1;
//                     end;
//                 end;
//         end;
//         WriteAction(JsonPayloalObject);
//         ReadTransDtls(DocumentNo, DocumentType, JsonPayloalObject);
//         ReadDocDtls(DocumentNo, DocumentType, JsonPayloalObject);
//         ReadExportDtls(DocumentNo, JsonPayloalObject);
//         ReadSellerDtls(DocumentNo, JsonPayloalObject);
//         ReadBuyerDtls(DocumentNo, JsonPayloalObject);
//         ReadDispatchDtls(DocumentNo, JsonPayloalObject);
//         ReadShipDtls(DocumentNo, JsonPayloalObject);
//         ReadValueDtls(DocumentNo, DocumentType, GLAccountRound1, GlAccountRound2, Currencyfactor, JsonPayloalObject);
//         ReadItemDetails(DocumentNo, DocumentType, JsonPayloalObject, GLAccountRound1, GlAccountRound2, Currencyfactor);
//         JsonPayloalObject.WriteTo(JsonPayload);
//         Message(JsonPayload);
//     end;

//     local procedure WriteAction(var JWriteActionObject: JsonObject)
//     begin
//         JWriteActionObject.Add('action', 'INVOICE');
//         JWriteActionObject.Add('Version', '1.1');
//         JWriteActionObject.Add('Irn', '');
//     end;

//     local procedure ReadTransDtls(DocumentNo: Code[20]; DocType: Option Invoice,"Creit Memo","Transfer Shipment"; var JTransDtlsValue: JsonObject)
//     var
//         Trans_DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
//         ReverseCharge: Code[1];
//         TransType: Text[6];
//     begin
//         Trans_DetailedGSTLedgerEntry.Reset();
//         Trans_DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
//         if Trans_DetailedGSTLedgerEntry.FindFirst() then begin

//             if Trans_DetailedGSTLedgerEntry."Reverse Charge" then
//                 ReverseCharge := 'Y'
//             else
//                 ReverseCharge := 'N';
//         end;
//         //Calculate Transaction Type
//         Trans_DetailedGSTLedgerEntry.Reset();
//         Trans_DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
//         if Trans_DetailedGSTLedgerEntry.FindFirst() then begin
//             IF Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::Registered THEN
//                 TransType := 'B2B';
//             IF ((Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit") OR (Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development"))
//               AND (NOT Trans_DetailedGSTLedgerEntry."GST Without Payment of Duty") THEN
//                 TransType := 'SEZWP';
//             IF ((Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Unit") OR (Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::"SEZ Development"))
//               AND (Trans_DetailedGSTLedgerEntry."GST Without Payment of Duty") THEN
//                 TransType := 'SEZWOP';
//             IF (Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::Export) AND (NOT Trans_DetailedGSTLedgerEntry."GST Without Payment of Duty") THEN
//                 TransType := 'EXPWP';
//             IF (Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::Export) AND (Trans_DetailedGSTLedgerEntry."GST Without Payment of Duty") THEN
//                 TransType := 'EXPWOP';
//             IF Trans_DetailedGSTLedgerEntry."GST Customer Type" = Trans_DetailedGSTLedgerEntry."GST Customer Type"::"Deemed Export" THEN
//                 TransType := 'DEXP';
//         end;

//         //Calculate Transaction Type

//         WriteTransDetails(JTransDtlsValue, ReverseCharge, TransType);
//     end;

//     local procedure WriteTransDetails(var JTransDtlsValue: JsonObject; ReverseCharge: Code[1]; TransType: Text[6])
//     var
//         JTransDtls: JsonObject;
//         JsonNull: JsonValue;
//     begin
//         JsonNull.SetValueToNull();
//         JTransDtls.Add('RevReverseCharge', ReverseCharge);
//         JTransDtls.Add('Typ', TransType);
//         JTransDtls.Add('TaxPayerType', 'GST');
//         JTransDtls.Add('EcomGstin', JsonNull);
//         JTransDtls.Add('IgstOnIntra', JsonNull);
//         JTransDtlsValue.Add('TpApiTranDtls', JTransDtls);
//     end;

//     local procedure ReadDocDtls(DocumentNo: Code[20]; DocuType: Option Invoice,"Creit Memo","Transfer Shipment"; var JReadDtls: JsonObject)
//     var
//         RdDoc_SalesInvoiceHeader: Record "Sales Invoice Header";
//         RdDoc_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//         RdDoc_TransferShipmentHeader: Record "Transfer Shipment Header";
//         DocumentNo1: Code[20];
//         PostingDate: Text;
//         DocType: Text[6];
//     begin

//         if RdDoc_SalesInvoiceHeader.get(DocumentNo) then begin
//             DocType := 'INV';
//             DocumentNo1 := RdDoc_SalesInvoiceHeader."No.";
//             PostingDate := FORMAT(RdDoc_SalesInvoiceHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//         end else
//             if RdDoc_SalesCrMemoHeader.get(DocumentNo) then begin
//                 DocType := 'CRN';
//                 DocumentNo1 := RdDoc_SalesCrMemoHeader."No.";
//                 PostingDate := FORMAT(RdDoc_SalesCrMemoHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//             end else
//                 if RdDoc_TransferShipmentHeader.get(DocumentNo) then begin
//                     DocType := 'INV';
//                     DocumentNo1 := RdDoc_TransferShipmentHeader."No.";
//                     PostingDate := FORMAT(RdDoc_TransferShipmentHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>');
//                 end;
//         WriteDocDtls(JReadDtls, DocType, DocumentNo1, PostingDate);
//     end;

//     local procedure WriteDocDtls(var JWriteDocValue: JsonObject; DocType: Text[6]; DocNo: Code[20]; PostingDate: Text)
//     var
//         JwriteDocDtls: JsonObject;
//     begin
//         JwriteDocDtls.Add('DocTyp', DocType);
//         JwriteDocDtls.Add('DocNo', DocNo);
//         JwriteDocDtls.Add('DocDate', PostingDate);
//         JWriteDocValue.Add('TpApiDocDtls', JwriteDocDtls);
//     end;

//     local procedure ReadExportDtls(DocumentNo: Code[20]; var JReadExpDtls: JsonObject)
//     var
//         Exp_SalesInvoiceHeader: Record "Sales Invoice Header";
//         Exp_SalesCreditMemoHeader: Record "Sales Cr.Memo Header";
//         CurrencyCode: Code[10];
//         Country: Record "Country/Region";
//         CountryCode: Code[2];
//         ExportCase: Boolean;
//     begin
//         ExportCase := false;
//         if Exp_SalesInvoiceHeader.get(DocumentNo) then begin
//             if Exp_SalesInvoiceHeader."GST Customer Type" = Exp_SalesInvoiceHeader."GST Customer Type"::Export then begin
//                 ExportCase := true;
//                 CurrencyCode := Exp_SalesInvoiceHeader."Currency Code";
//                 if Country.get(Exp_SalesInvoiceHeader."Bill-to Country/Region Code") then
//                     CountryCode := Country."Country Code for E Invoicing";
//             end;
//         end else
//             if Exp_SalesCreditMemoHeader.get(DocumentNo) then begin
//                 if Exp_SalesCreditMemoHeader."GST Customer Type" = Exp_SalesCreditMemoHeader."GST Customer Type"::Export then begin
//                     ExportCase := true;
//                     CurrencyCode := Exp_SalesCreditMemoHeader."Currency Code";
//                     if Country.get(Exp_SalesCreditMemoHeader."Bill-to Country/Region Code") then
//                         CountryCode := Country."Country Code for E Invoicing";
//                 end;
//             end;
//         WriteExpDtls(JReadExpDtls, CurrencyCode, CountryCode, ExportCase);
//     end;

//     local procedure WriteExpDtls(var JWriteExpValue: JsonObject; CuureCode: Code[10]; CoutryCode: Code[2]; ISExport: Boolean)
//     var
//         JWriteExpDtls: JsonObject;
//         JsonValueNull: JsonValue;
//     begin
//         JsonValueNull.SetValueToNull();
//         if ISExport then begin
//             JWriteExpDtls.Add('ShippingBillNo', JsonValueNull);
//             JWriteExpDtls.Add('ShippingBillDate', JsonValueNull);
//             JWriteExpDtls.Add('PortCode', JsonValueNull);
//             JWriteExpDtls.Add('ForeignCurrency', CuureCode);
//             JWriteExpDtls.Add('CountryCode', CoutryCode);
//             JWriteExpDtls.Add('RefundClaim', JsonValueNull);
//             JWriteExpDtls.Add('ExportDuty', 0);
//             JWriteExpValue.Add('TpApiExpDtls', JWriteExpDtls);
//         end else
//             JWriteExpValue.Add('TpApiExpDtls', JsonValueNull);
//     end;

//     local procedure ReadSellerDtls(DocNo: Code[20]; var JSellerDtls: JsonObject)
//     var
//         Sell_SalesInvoiceHeader: Record "Sales Invoice Header";
//         Sell_SalesCreditMemoHeader: Record "Sales Cr.Memo Header";
//         Sell_TransferShipmentHeader: Record "Transfer Shipment Header";
//         Sell_Location: Record Location;
//         Sell_State: Record State;
//         SGSTIN: Code[15];
//         SLglName: Text[150];
//         STrdName: Text[150];
//         SAddrs1: Text[100];
//         SAddrs2: Text[50];
//         SLocCity: Text[30];
//         SPostCode: Code[20];
//         S_StateCode: Code[10];
//         SPhNo: Text[30];
//         SEmail: Text[80];
//     begin
//         if Sell_SalesInvoiceHeader.get(DocNo) then begin
//             if Sell_Location.get(Sell_SalesInvoiceHeader."Location Code") then begin
//                 SGSTIN := Sell_Location."GST Registration No.";
//                 SLglName := DelString(Sell_Location.Name) + DelString((Sell_Location."Name 2"));
//                 STrdName := DelString(Sell_Location.Name) + DelString((Sell_Location."Name 2"));
//                 SAddrs1 := DelString(Sell_Location.Address);
//                 if Sell_Location."Address 2" <> '' then
//                     SAddrs2 := DelString(Sell_Location."Address 2")
//                 else
//                     SAddrs2 := '';
//                 SLocCity := Sell_Location.City;
//                 SPostCode := Sell_Location."Post Code";
//                 if Sell_State.Get(Sell_Location."State Code") then
//                     S_StateCode := Sell_State."State Code for E-Invoicing";
//                 SPhNo := Sell_Location."Phone No.";
//                 SEmail := Format(Sell_Location."E-Mail");
//             end;
//         end else
//             if Sell_SalesCreditMemoHeader.get(DocNo) then begin
//                 if Sell_Location.get(Sell_SalesCreditMemoHeader."Location Code") then begin
//                     SGSTIN := Sell_Location."GST Registration No.";
//                     SLglName := DelString(Sell_Location.Name) + DelString((Sell_Location."Name 2"));
//                     STrdName := DelString(Sell_Location.Name) + DelString((Sell_Location."Name 2"));
//                     SAddrs1 := DelString(Sell_Location.Address);
//                     if Sell_Location."Address 2" <> '' then
//                         SAddrs2 := DelString(Sell_Location."Address 2")
//                     else
//                         SAddrs2 := '';
//                     SLocCity := Sell_Location.City;
//                     SPostCode := Sell_Location."Post Code";
//                     if Sell_State.Get(Sell_Location."State Code") then
//                         S_StateCode := Sell_State."State Code for E-Invoicing";
//                     SPhNo := Sell_Location."Phone No.";
//                     SEmail := Format(Sell_Location."E-Mail");
//                 end;
//             end else
//                 if Sell_TransferShipmentHeader.get(DocNo) then begin
//                     if Sell_Location.GET(Sell_TransferShipmentHeader."Transfer-from Code") then;
//                     SGSTIN := Sell_Location."GST Registration No.";
//                     SLglName := DelString(Sell_TransferShipmentHeader."Transfer-from Name") + DelString((Sell_TransferShipmentHeader."Transfer-from Name 2"));
//                     STrdName := DelString(Sell_TransferShipmentHeader."Transfer-from Name") + DelString((Sell_TransferShipmentHeader."Transfer-from Name 2"));
//                     SAddrs1 := DelString(Sell_TransferShipmentHeader."Transfer-from Address");
//                     if Sell_TransferShipmentHeader."Transfer-from Address 2" <> '' then
//                         SAddrs2 := DelString(Sell_TransferShipmentHeader."Transfer-from Address 2")
//                     else
//                         SAddrs2 := '';
//                     SLocCity := Sell_Location.City;
//                     SPostCode := Sell_Location."Post Code";
//                     if Sell_State.Get(Sell_Location."State Code") then
//                         S_StateCode := Sell_State."State Code for E-Invoicing";
//                     SPhNo := Sell_Location."Phone No.";
//                     SEmail := Format(Sell_Location."E-Mail");
//                 end;
//         WriteSellerDtls(JSellerDtls, SGSTIN, SLglName, STrdName, SAddrs1, SAddrs2, SLocCity, SPostCode, S_StateCode, SPhNo, SEmail);
//     end;

//     local procedure WriteSellerDtls(var jWriteSellerValue: JsonObject; GSTIN: Code[15]; LglName: Text[150]; TrdName: Text[150]; Addrs1: Text[100]; Addrs2: Text[50];
//                                       LocCity: Text[30]; PostCode: Code[20]; StateCode: Code[10]; PhNo: Text[30]; Email: Text[80])
//     var
//         JSellerDtls: JsonObject;
//         JsonNull: JsonValue;
//     begin
//         JsonNull.SetValueToNull();
//         JSellerDtls.Add('GstinNo', GSTIN);
//         JSellerDtls.Add('LegalName', LglName);
//         JSellerDtls.Add('TrdName', TrdName);
//         JSellerDtls.Add('Address1', Addrs1);
//         if Addrs2 <> '' then
//             JSellerDtls.Add('Address2', Addrs2)
//         else
//             JSellerDtls.Add('Address2', JsonNull);
//         JSellerDtls.Add('Location', LocCity);
//         JSellerDtls.Add('Pincode', PostCode);
//         JSellerDtls.Add('StateCode', StateCode);
//         if PhNo <> '' then
//             JSellerDtls.Add('MobileNo', PhNo)
//         else
//             JSellerDtls.Add('MobileNo', JsonNull);
//         if Email <> '' then
//             JSellerDtls.Add('EmailId', Email)
//         else
//             JSellerDtls.Add('EmailId', JsonNull);
//         jWriteSellerValue.Add('TpApiSellerDtls', JSellerDtls);
//     end;

//     local procedure ReadBuyerDtls(DocumentNo: Code[20]; var JReadBuyerValue: JsonObject)
//     var
//         Buyr_SalesInvoiceHeader: Record "Sales Invoice Header";
//         Buyr_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//         Buyr_TransfershipmentHeader: Record "Transfer Shipment Header";
//         Buyr_DetailedGSTLedgeEntry: Record "Detailed GST Ledger Entry";
//         Buyr_Location: Record Location;
//         Buyr_State: Record State;
//         BuyrGSTIN: Code[15];
//         BLglName: Text[150];
//         BTrdName: Text[150];
//         BPlaceSupply: Code[2];
//         BAddrs1: Text[100];
//         BAddrs2: Text[50];
//         BLocCity: Text[30];
//         BPostCode: Code[20];
//         B_StateCode: Code[10];
//         BPhNo: Text[30];
//         BEmail: Text[80];
//     begin
//         if Buyr_SalesInvoiceHeader.get(DocumentNo) then begin
//             BuyrGSTIN := Buyr_SalesInvoiceHeader."Customer GST Reg. No.";
//             if (Buyr_SalesInvoiceHeader."GST Customer Type" = Buyr_SalesInvoiceHeader."GST Customer Type"::Unregistered) or
//               (Buyr_SalesInvoiceHeader."GST Customer Type" = Buyr_SalesInvoiceHeader."GST Customer Type"::Export) then begin
//                 BuyrGSTIN := 'URP';
//             end;
//             BLglName := DelString(Buyr_SalesInvoiceHeader."Bill-to Name") + DelString(Buyr_SalesInvoiceHeader."Bill-to Name 2");
//             BTrdName := DelString(Buyr_SalesInvoiceHeader."Bill-to Name") + DelString(Buyr_SalesInvoiceHeader."Bill-to Name 2");
//             if Buyr_State.get(Buyr_SalesInvoiceHeader."GST Bill-to State Code") then
//                 BPlaceSupply := Buyr_State."State Code (GST Reg. No.)"
//             else
//                 BPlaceSupply := '96';
//             BAddrs1 := DelString(Buyr_SalesInvoiceHeader."Bill-to Address");
//             BAddrs2 := DelString(Buyr_SalesInvoiceHeader."Bill-to Address 2");
//             BLocCity := Buyr_SalesInvoiceHeader."Bill-to City";
//             if Buyr_SalesInvoiceHeader."GST Customer Type" = Buyr_SalesInvoiceHeader."GST Customer Type"::Export then begin
//                 BPostCode := '999999';
//                 B_StateCode := '96';
//             end else begin
//                 BPostCode := Buyr_SalesInvoiceHeader."Bill-to Post Code";
//                 Buyr_State.Reset();
//                 if Buyr_State.get(Buyr_SalesInvoiceHeader."GST Bill-to State Code") then
//                     B_StateCode := Buyr_State."State Code for E-Invoicing";
//             end;
//             BPhNo := Buyr_SalesInvoiceHeader."Bill-to Contact No.";
//             BEmail := '';
//         end;
//         if Buyr_SalesCrMemoHeader.get(DocumentNo) then begin
//             BuyrGSTIN := Buyr_SalesCrMemoHeader."Customer GST Reg. No.";
//             if (Buyr_SalesCrMemoHeader."GST Customer Type" = Buyr_SalesCrMemoHeader."GST Customer Type"::Unregistered) or
//               (Buyr_SalesCrMemoHeader."GST Customer Type" = Buyr_SalesCrMemoHeader."GST Customer Type"::Export) then begin
//                 BuyrGSTIN := 'URP';
//             end;
//             BLglName := DelString(Buyr_SalesCrMemoHeader."Bill-to Name") + DelString(Buyr_SalesCrMemoHeader."Bill-to Name 2");
//             BTrdName := DelString(Buyr_SalesCrMemoHeader."Bill-to Name") + DelString(Buyr_SalesCrMemoHeader."Bill-to Name 2");
//             if Buyr_State.get(Buyr_SalesCrMemoHeader."GST Bill-to State Code") then
//                 BPlaceSupply := Buyr_State."State Code (GST Reg. No.)"
//             else
//                 BPlaceSupply := '96';
//             BAddrs1 := DelString(Buyr_SalesCrMemoHeader."Bill-to Address");
//             BAddrs2 := DelString(Buyr_SalesCrMemoHeader."Bill-to Address 2");
//             BLocCity := Buyr_SalesCrMemoHeader."Bill-to City";
//             if Buyr_SalesCrMemoHeader."GST Customer Type" = Buyr_SalesCrMemoHeader."GST Customer Type"::Export then begin
//                 BPostCode := '999999';
//                 B_StateCode := '96';
//             end else begin
//                 BPostCode := Buyr_SalesCrMemoHeader."Bill-to Post Code";
//                 Buyr_State.Reset();
//                 if Buyr_State.get(Buyr_SalesCrMemoHeader."GST Bill-to State Code") then
//                     B_StateCode := Buyr_State."State Code for E-Invoicing";
//             end;
//             BPhNo := Buyr_SalesCrMemoHeader."Bill-to Contact No.";
//             BEmail := '';
//         end;
//         if Buyr_TransfershipmentHeader.Get(DocumentNo) then begin
//             Buyr_DetailedGSTLedgeEntry.Reset();
//             Buyr_DetailedGSTLedgeEntry.SetRange("Document No.", Buyr_TransfershipmentHeader."No.");
//             if Buyr_DetailedGSTLedgeEntry.FindFirst() then begin
//                 if Buyr_DetailedGSTLedgeEntry."GST Customer Type" = Buyr_DetailedGSTLedgeEntry."GST Customer Type"::Unregistered then
//                     BuyrGSTIN := 'URP';
//                 if Buyr_DetailedGSTLedgeEntry."GST Customer Type" = Buyr_DetailedGSTLedgeEntry."GST Customer Type"::Registered then
//                     BuyrGSTIN := Buyr_DetailedGSTLedgeEntry."Buyer/Seller Reg. No.";
//                 BLglName := DelString(Buyr_TransfershipmentHeader."Transfer-to Name") + DelString(Buyr_TransfershipmentHeader."Transfer-from Name 2");
//                 BTrdName := DelString(Buyr_TransfershipmentHeader."Transfer-to Name") + DelString(Buyr_TransfershipmentHeader."Transfer-from Name 2");
//                 Buyr_Location.RESET;
//                 Buyr_Location.GET(Buyr_TransfershipmentHeader."Transfer-to Code");
//                 Buyr_State.RESET;
//                 IF Buyr_State.GET(Buyr_Location."State Code") THEN
//                     BPlaceSupply := Buyr_State."State Code (GST Reg. No.)"
//                 ELSE
//                     BPlaceSupply := '96';
//                 BAddrs1 := DelString(Buyr_TransfershipmentHeader."Transfer-to Address");
//                 BAddrs2 := DelString(Buyr_TransfershipmentHeader."Transfer-from Address 2");
//                 BLocCity := Buyr_TransfershipmentHeader."Transfer-to City";
//                 BPostCode := Buyr_Location."Post Code";
//                 Buyr_State.Reset();
//                 if Buyr_State.Get(Buyr_Location."State Code") then
//                     B_StateCode := Buyr_State."State Code for E-Invoicing";
//                 BPhNo := '';
//                 BEmail := ''
//             end;
//         end;
//         WriteBuyerDtls(JReadBuyerValue, BuyrGSTIN, BLglName, BTrdName, BPlaceSupply, BAddrs1, BAddrs2, BLocCity, BPostCode, B_StateCode, BPhNo, BEmail);
//     end;

//     local procedure WriteBuyerDtls(var JbuyerValue: JsonObject; GSTIN: Code[15]; LglName: Text[150]; TrdName: Text[150]; BPlaceSuppy: Code[2]; Addrs1: Text[100]; Addrs2: Text[50];
//                                       LocCity: Text[30]; PostCode: Code[20]; StateCode: Code[10]; PhNo: Text[30]; Email: Text[80])
//     var
//         JBuyerDtls: JsonObject;
//         JsonNull: JsonValue;
//     begin
//         JsonNull.SetValueToNull();
//         JBuyerDtls.Add('GstinNo', GSTIN);
//         JBuyerDtls.Add('LegalName', LglName);
//         JBuyerDtls.Add('TrdName', TrdName);
//         JBuyerDtls.Add('PlaceOfSupply', BPlaceSuppy);
//         JBuyerDtls.Add('Address1', Addrs1);
//         if Addrs2 <> '' then
//             JBuyerDtls.Add('Address2', Addrs2)
//         else
//             JBuyerDtls.Add('Address2', JsonNull);
//         JBuyerDtls.Add('Location', LocCity);
//         JBuyerDtls.Add('Pincode', PostCode);
//         JBuyerDtls.Add('StateCode', StateCode);
//         if PhNo <> '' then
//             JBuyerDtls.Add('MobileNo', PhNo)
//         else
//             JBuyerDtls.Add('MobileNo', JsonNull);
//         if Email <> '' then
//             JBuyerDtls.Add('EmailId', Email)
//         else
//             JBuyerDtls.Add('EmailId', JsonNull);
//         JbuyerValue.Add('TpApiBuyerDtls', JBuyerDtls);
//     end;

//     local procedure ReadDispatchDtls(DocNo: Code[20]; var JReadValue: JsonObject)
//     begin
//         WriteDispatcDtls(JReadValue);
//     end;

//     local procedure WriteDispatcDtls(var JwriteDispDtlsValue: JsonObject)
//     var
//         JsonNull: JsonValue;
//     begin
//         JsonNull.SetValueToNull();
//         JwriteDispDtlsValue.Add('TpApiDispDtls', JsonNull);
//     end;

//     local procedure ReadShipDtls(DocNo: Code[20]; var JReadShipDtlValue: JsonObject)
//     var
//         Ship_SalesInvoiceHeader: Record "Sales Invoice Header";
//         Ship_SalesCreditMemoHeader: Record "Sales Cr.Memo Header";
//         Ship_ShiptoAddress: Record "Ship-to Address";
//         Ship_State: Record State;
//         ShGSTIN: Code[15];
//         ShLglName: Text[150];
//         ShTrdName: Text[150];
//         ShAddrs1: Text[100];
//         ShAddrs2: Text[50];
//         ShLocCity: Text[30];
//         ShPostCode: Code[20];
//         Sh_StateCode: Code[10];
//         IsShipDtls: Boolean;
//     begin
//         IsShipDtls := false;
//         if Ship_SalesInvoiceHeader.get(DocNo) then begin
//             if Ship_SalesInvoiceHeader."Ship-to Code" <> '' then begin
//                 IsShipDtls := true;
//                 if Ship_ShiptoAddress.get(Ship_SalesInvoiceHeader."Sell-to Customer No.", Ship_SalesInvoiceHeader."Ship-to Code") then;
//                 if Ship_ShiptoAddress."GST Registration No." <> '' then
//                     ShGSTIN := Ship_ShiptoAddress."GST Registration No."
//                 else
//                     ShGSTIN := '';
//                 if Ship_SalesInvoiceHeader."GST Customer Type" = Ship_SalesInvoiceHeader."GST Customer Type"::Export then
//                     ShGSTIN := '';
//                 ShLglName := DelString(Ship_SalesInvoiceHeader."Ship-to Name") + DelString(Ship_SalesInvoiceHeader."Ship-to Name 2");
//                 ShTrdName := DelString(Ship_SalesInvoiceHeader."Ship-to Name") + DelString(Ship_SalesInvoiceHeader."Ship-to Name 2");
//                 ShAddrs1 := DelString(Ship_SalesInvoiceHeader."Ship-to Address");
//                 if Ship_SalesInvoiceHeader."Ship-to Address 2" <> '' then
//                     ShAddrs2 := DelString(Ship_SalesInvoiceHeader."Ship-to Address 2")
//                 else
//                     ShAddrs2 := '';
//                 ShLocCity := Ship_SalesInvoiceHeader."Ship-to City";
//                 if (Ship_SalesInvoiceHeader."GST Customer Type" = Ship_SalesInvoiceHeader."GST Customer Type"::Export) and (Ship_SalesInvoiceHeader."GST Ship-to State Code" = '') then begin
//                     ShPostCode := '999999';
//                     Sh_StateCode := '96';
//                 end else begin
//                     if Ship_State.get(Ship_SalesInvoiceHeader."GST Ship-to State Code") then
//                         Sh_StateCode := Ship_State."State Code for E-Invoicing";
//                     ShPostCode := Ship_SalesInvoiceHeader."Ship-to Post Code";
//                 end;
//             end;
//         end else
//             if Ship_SalesCreditMemoHeader.get(DocNo) then begin
//                 if Ship_SalesCreditMemoHeader."Ship-to Code" <> '' then begin
//                     IsShipDtls := true;
//                     if Ship_ShiptoAddress.get(Ship_SalesCreditMemoHeader."Sell-to Customer No.", Ship_SalesCreditMemoHeader."Ship-to Code") then;
//                     if Ship_ShiptoAddress."GST Registration No." <> '' then
//                         ShGSTIN := Ship_ShiptoAddress."GST Registration No."
//                     else
//                         ShGSTIN := '';
//                     if Ship_SalesCreditMemoHeader."GST Customer Type" = Ship_SalesCreditMemoHeader."GST Customer Type"::Export then
//                         ShGSTIN := '';
//                     ShLglName := DelString(Ship_SalesCreditMemoHeader."Ship-to Name") + DelString(Ship_SalesCreditMemoHeader."Ship-to Name 2");
//                     ShTrdName := DelString(Ship_SalesCreditMemoHeader."Ship-to Name") + DelString(Ship_SalesCreditMemoHeader."Ship-to Name 2");
//                     ShAddrs1 := DelString(Ship_SalesCreditMemoHeader."Ship-to Address");
//                     if Ship_SalesCreditMemoHeader."Ship-to Address 2" <> '' then
//                         ShAddrs2 := DelString(Ship_SalesCreditMemoHeader."Ship-to Address 2")
//                     else
//                         ShAddrs2 := '';
//                     ShLocCity := Ship_SalesCreditMemoHeader."Ship-to City";
//                     if (Ship_SalesCreditMemoHeader."GST Customer Type" = Ship_SalesCreditMemoHeader."GST Customer Type"::Export) and (Ship_SalesCreditMemoHeader."GST Ship-to State Code" = '') then begin
//                         ShPostCode := '999999';
//                         Sh_StateCode := '96';
//                     end else begin
//                         if Ship_State.get(Ship_SalesCreditMemoHeader."GST Ship-to State Code") then
//                             ShPostCode := Ship_SalesCreditMemoHeader."Ship-to Post Code";
//                         Sh_StateCode := Ship_State."State Code for E-Invoicing";
//                     end;
//                 end;
//             end;
//         WriteShipDtls(JReadShipDtlValue, ShGSTIN, ShLglName, ShTrdName, ShAddrs1, ShAddrs2, ShLocCity, ShPostCode, Sh_StateCode, IsShipDtls);
//     end;

//     local procedure WriteShipDtls(Var JShipDtlsValue: JsonObject; ShGSTIN: Code[15]; ShLglName: Text[150]; ShTrdName: Text[150]; ShAddrs1: Text[100]; ShAddrs2: Text[50];
//         ShLocCity: Text[30]; ShPostCode: Code[20]; Sh_StateCode: Code[10]; IsShipDtls: Boolean)
//     var
//         JShipDtls: JsonObject;
//         JsonSNull: JsonValue;
//     begin
//         JsonSNull.SetValueToNull();
//         if IsShipDtls then begin
//             if ShGSTIN <> '' then
//                 JShipDtls.Add('GstinNo', ShGSTIN)
//             else
//                 JShipDtls.Add('GstinNo', JsonSNull);
//             JShipDtls.Add('LegalName', ShLglName);
//             JShipDtls.Add('TrdName', ShTrdName);
//             JShipDtls.Add('Address1', ShAddrs1);
//             if ShAddrs2 <> '' then
//                 JShipDtls.Add('Address2', ShAddrs2)
//             else
//                 JShipDtls.Add('Address2', JsonSNull);
//             if ShLocCity <> '' then
//                 JShipDtls.Add('Location', ShLocCity)
//             else
//                 JShipDtls.Add('Location', JsonSNull);
//             JShipDtls.Add('Pincode', ShPostCode);
//             JShipDtls.Add('StateCode', Sh_StateCode);
//             JShipDtlsValue.Add('TpApiShipDtls', JShipDtls);
//         end else
//             JShipDtlsValue.Add('TpApiShipDtls', JsonSNull);
//     end;

//     local procedure ReadValueDtls(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; GLAccount_Round_1: Code[20];
//         GLAccount_Round_2: Code[20]; CurrencyFactor: Decimal; var JRedValueDtls: JsonObject)
//     var
//         Val_DetailedGSTEntry: Record "Detailed GST Ledger Entry";
//         Val_SalesInvoiceLine: Record "Sales Invoice Line";
//         Val_SalesCrMemoLine: Record "Sales Cr.Memo Line";
//         Val_CustLedgerEntry: Record "Cust. Ledger Entry";
//         Val_TransferShipmentLine: Record "Transfer Shipment Line";
//         GSTBaseAmt: Decimal;
//         CGSTAmt: Decimal;
//         SGSTAmt: Decimal;
//         IGSTAmt: Decimal;
//         TotalInvValue: Decimal;
//         TotalInvValueFC: Decimal;
//         DiscountAmt: Decimal;
//         RoundOffAmt: Decimal;
//     begin
//         Val_DetailedGSTEntry.RESET;
//         Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
//         Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'CGST');
//         Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
//         CGSTAmt := ABS(Val_DetailedGSTEntry."GST Amount");
//         GSTBaseAmt := ABS(Val_DetailedGSTEntry."GST Base Amount");

//         Val_DetailedGSTEntry.RESET;
//         Val_DetailedGSTEntry.SETRANGE("Document No.", DocNo);
//         Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'IGST');
//         Val_DetailedGSTEntry.CALCSUMS("GST Amount", "GST Base Amount");
//         IGSTAmt := ABS(Val_DetailedGSTEntry."GST Amount");
//         IF GSTBaseAmt = 0 THEN
//             GSTBaseAmt := ABS(Val_DetailedGSTEntry."GST Base Amount");

//         Val_DetailedGSTEntry.Reset();
//         Val_DetailedGSTEntry.SetRange("Document No.", DocNo);
//         Val_DetailedGSTEntry.SETRANGE("GST Component Code", 'SGST');
//         Val_DetailedGSTEntry.CALCSUMS("GST Amount");
//         SGSTAmt := ABS(Val_DetailedGSTEntry."GST Amount");

//         Val_CustLedgerEntry.RESET;
//         Val_CustLedgerEntry.SETAUTOCALCFIELDS("Original Amt. (LCY)", Amount);
//         Val_CustLedgerEntry.SETRANGE("Document No.", DocNo);
//         if Val_CustLedgerEntry.FINDFIRST then begin
//             TotalInvValue := abs(Val_CustLedgerEntry."Original Amt. (LCY)");
//             TotalInvValueFC := abs(Val_CustLedgerEntry.Amount);
//         end;
//         case
//           DocumentType of
//             DocumentType::Invoice:
//                 begin
//                     Val_SalesInvoiceLine.Reset();
//                     Val_SalesInvoiceLine.SetRange("Document No.", DocNo);
//                     Val_SalesInvoiceLine.SetFilter("No.", '<>%1&<>%2', GLAccount_Round_1, GLAccount_Round_2);
//                     Val_SalesInvoiceLine.CalcSums("Line Discount Amount");
//                     DiscountAmt := abs(Val_SalesInvoiceLine."Line Discount Amount" / CurrencyFactor);

//                     Val_SalesInvoiceLine.Reset();
//                     Val_SalesInvoiceLine.SetRange("Document No.", DocNo);
//                     Val_SalesInvoiceLine.SetRange(Type, Val_SalesInvoiceLine.Type::"G/L Account");
//                     Val_SalesInvoiceLine.SetFilter("No.", '%1&%2', GLAccount_Round_1, GLAccount_Round_2);
//                     Val_SalesInvoiceLine.CalcSums("Line Amount");
//                     RoundOffAmt := abs(Val_SalesInvoiceLine."Line Amount" / CurrencyFactor);
//                 end;
//             DocumentType::"Credit Memo":
//                 begin
//                     Val_SalesCrMemoLine.Reset();
//                     Val_SalesCrMemoLine.SetRange("Document No.", DocNo);
//                     Val_SalesCrMemoLine.SetFilter("No.", '<>%1&<>%2', GLAccount_Round_1, GLAccount_Round_2);
//                     Val_SalesCrMemoLine.CalcSums("Line Discount Amount");
//                     DiscountAmt := abs(Val_SalesCrMemoLine."Line Discount Amount" / CurrencyFactor);

//                     Val_SalesCrMemoLine.Reset();
//                     Val_SalesCrMemoLine.SetRange("Document No.", DocNo);
//                     Val_SalesCrMemoLine.SetRange(Type, Val_SalesCrMemoLine.Type::"G/L Account");
//                     Val_SalesCrMemoLine.SetFilter("No.", '%1&%2', GLAccount_Round_1, GLAccount_Round_2);
//                     Val_SalesCrMemoLine.CalcSums("Line Amount");
//                     RoundOffAmt := abs(Val_SalesCrMemoLine."Line Amount" / CurrencyFactor);
//                 end;
//             DocumentType::"Transfer Shipment":
//                 begin
//                     TotalInvValue := abs(GSTBaseAmt + IGSTAmt + CGSTAmt + SGSTAmt);
//                     TotalInvValueFC := abs(GSTBaseAmt + IGSTAmt + CGSTAmt + SGSTAmt);
//                     Val_TransferShipmentLine.Reset();
//                     Val_TransferShipmentLine.SetRange("Document No.", DocNo);
//                     Val_TransferShipmentLine.SetFilter("Item No.", '%1&%2', GLAccount_Round_1, GLAccount_Round_2);
//                     Val_TransferShipmentLine.CalcSums(Amount);
//                     DiscountAmt := 0;
//                     RoundOffAmt := abs(Val_TransferShipmentLine.Amount);
//                 end;
//         end;
//         WriteValDetails(JRedValueDtls, GSTBaseAmt, CGSTAmt, SGSTAmt, IGSTAmt, TotalInvValue, RoundOffAmt, TotalInvValueFC, DiscountAmt);
//     end;

//     local procedure WriteValDetails(var JWriteValValue: JsonObject; GSTBaseAmt: Decimal; CGSTAmt: Decimal; SGSTAmt: Decimal; IGSTAmt: Decimal;
//         TotalInvValue: Decimal; RoundOffAmt: Decimal; TotalInvValueFC: Decimal; DiscountAmt: Decimal)
//     var
//         JWritevalDtls: JsonObject;
//     begin
//         JWritevalDtls.Add('TotalTaxableVal', ReturnStr(RoundAmt(GSTBaseAmt)));
//         JWritevalDtls.Add('TotalSgstVal', ReturnStr(RoundAmt(SGSTAmt)));
//         JWritevalDtls.Add('TotalCgstVal', ReturnStr(RoundAmt(CGSTAmt)));
//         JWritevalDtls.Add('TotalIgstVal', ReturnStr(RoundAmt(IGSTAmt)));
//         JWritevalDtls.Add('TotalCesVal', 0);
//         JWritevalDtls.Add('TotalStateCesVal', 0);
//         JWritevalDtls.Add('TotInvoiceVal', ReturnStr(RoundAmt(TotalInvValue)));
//         JWritevalDtls.Add('RoundOfAmt', ReturnStr(RoundAmt(RoundOffAmt)));
//         JWritevalDtls.Add('TotalInvValueFc', ReturnStr(RoundAmt(TotalInvValueFC)));
//         JWritevalDtls.Add('Discount', ReturnStr(RoundAmt(DiscountAmt)));
//         JWritevalDtls.Add('OthCharge', 0);
//         JWriteValValue.Add('TpApiValDtls', JWritevalDtls);
//     end;

//     local procedure ReadItemDetails(DocNo: Code[20]; DocumentType: Option " ",Invoice,"Credit Memo","Transfer Shipment"; var JReadItemValue: JsonObject; GLAccount_Round_1: Code[20];
//         GLAccount_Round_2: Code[20]; CuurencyFactor: Decimal)
//     var
//         Item_SalesInvoiceLine: Record "Sales Invoice Line";
//         Item_SalesCreditMemoLine: Record "Sales Cr.Memo Line";
//         Item_TranferShipmentLine: Record "Transfer Shipment Line";
//         UnitofMeasure: Record "Unit of Measure";
//         SiNo: Integer;
//         ProductDesc: Text[100];
//         ProductDesc2: Text[50];
//         IsService: Text[10];
//         HSNCode: Code[10];
//         Quantity: Decimal;
//         FreeQuantity: Decimal;
//         UOM: Code[10];
//         UnitPrice: Decimal;
//         TotalAmt: Decimal;
//         LineDiscountAmt: Decimal;
//         GSTBaseAmtLine: Decimal;
//         GSTPer: Decimal;
//         SGSTAmtLine: Decimal;
//         CGSTAmtLine: Decimal;
//         IGSTAmtLine: Decimal;
//         TotalItemValue: Decimal;
//         JItemArray: JsonArray;
//     begin
//         SiNo := 0;
//         JReadItemValue.Add('TpApiItemList', JItemArray);
//         case
//             DocumentType of
//             DocumentType::Invoice:
//                 begin
//                     Item_SalesInvoiceLine.Reset();
//                     Item_SalesInvoiceLine.SetRange("Document No.", DocNo);
//                     Item_SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
//                     Item_SalesInvoiceLine.SetFilter("No.", '<>%1&<>%2', GLAccount_Round_1, GLAccount_Round_2);
//                     if Item_SalesInvoiceLine.FindSet() then
//                         repeat
//                             SiNo += 1;
//                             ProductDesc := Item_SalesInvoiceLine.Description;
//                             ProductDesc2 := Item_SalesInvoiceLine."Description 2";
//                             if Item_SalesInvoiceLine.Type in [Item_SalesInvoiceLine.Type::"G/L Account", Item_SalesInvoiceLine.Type::Resource] then
//                                 IsService := 'Y'
//                             else
//                                 IsService := 'N';
//                             HSNCode := Item_SalesInvoiceLine."HSN/SAC Code";
//                             Quantity := abs(Item_SalesInvoiceLine.Quantity);
//                             UnitofMeasure.RESET;
//                             UnitofMeasure.SETRANGE(Code, Item_SalesInvoiceLine."Unit of Measure Code");
//                             IF UnitofMeasure.FINDFIRST THEN
//                                 UOM := UnitofMeasure."UOM For E Invoicing"
//                             ELSE
//                                 UOM := 'OTH';
//                             UnitPrice := abs(Item_SalesInvoiceLine."Unit Price" / CuurencyFactor);
//                             TotalAmt := abs((Item_SalesInvoiceLine.Quantity * Item_SalesInvoiceLine."Unit Price") / CuurencyFactor);
//                             LineDiscountAmt := abs(Item_SalesInvoiceLine."Line Discount Amount" / CuurencyFactor);
//                             GetGSTValueForLine(Item_SalesInvoiceLine."Document No.", Item_SalesInvoiceLine."Line No.", GSTBaseAmtLine, SGSTAmtLine, GSTPer,
//                                 CGSTAmtLine, IGSTAmtLine);

//                             TotalItemValue := abs(GSTBaseAmtLine + SGSTAmtLine + CGSTAmtLine + IGSTAmtLine + GetTCSAmount(Item_SalesInvoiceLine."Document No.", Item_SalesInvoiceLine."Line No.", 2));
//                             WriteItemList(JItemArray, SiNo, ProductDesc, ProductDesc2, IsService, HSNCode, Quantity, 0, UOM, UnitPrice, TotalAmt, LineDiscountAmt, GSTBaseAmtLine,
//                                 GSTPer, SGSTAmtLine, CGSTAmtLine, IGSTAmtLine, TotalItemValue);
//                         until Item_SalesInvoiceLine.Next() = 0;
//                 end;
//             DocumentType::"Credit Memo":
//                 begin
//                     Item_SalesCreditMemoLine.Reset();
//                     Item_SalesCreditMemoLine.SetRange("Document No.", DocNo);
//                     Item_SalesCreditMemoLine.SetFilter(Quantity, '<>%1', 0);
//                     Item_SalesCreditMemoLine.SetFilter("No.", '<>%1&<>%2', GLAccount_Round_1, GLAccount_Round_2);
//                     if Item_SalesCreditMemoLine.FindSet() then
//                         repeat
//                             SiNo += 1;
//                             ProductDesc := Item_SalesCreditMemoLine.Description;
//                             ProductDesc2 := Item_SalesCreditMemoLine."Description 2";
//                             if Item_SalesCreditMemoLine.Type in [Item_SalesCreditMemoLine.Type::"G/L Account", Item_SalesCreditMemoLine.Type::Resource] then
//                                 IsService := 'Y'
//                             else
//                                 IsService := 'N';
//                             HSNCode := Item_SalesCreditMemoLine."HSN/SAC Code";
//                             Quantity := abs(Item_SalesCreditMemoLine.Quantity);
//                             UnitofMeasure.RESET;
//                             UnitofMeasure.SETRANGE(Code, Item_SalesCreditMemoLine."Unit of Measure Code");
//                             IF UnitofMeasure.FINDFIRST THEN
//                                 UOM := UnitofMeasure."UOM For E Invoicing"
//                             ELSE
//                                 UOM := 'OTH';
//                             UnitPrice := abs(Item_SalesCreditMemoLine."Unit Price" / CuurencyFactor);
//                             TotalAmt := abs((Item_SalesCreditMemoLine.Quantity * Item_SalesCreditMemoLine."Unit Price") / CuurencyFactor);
//                             LineDiscountAmt := abs(Item_SalesCreditMemoLine."Line Discount Amount" / CuurencyFactor);
//                             GetGSTValueForLine(Item_SalesCreditMemoLine."Document No.", Item_SalesCreditMemoLine."Line No.", GSTBaseAmtLine, SGSTAmtLine, GSTPer,
//                                 CGSTAmtLine, IGSTAmtLine);

//                             TotalItemValue := abs(GSTBaseAmtLine + SGSTAmtLine + CGSTAmtLine + IGSTAmtLine + GetTCSAmount(Item_SalesCreditMemoLine."Document No.", Item_SalesCreditMemoLine."Line No.", 3));
//                             WriteItemList(JItemArray, SiNo, ProductDesc, ProductDesc2, IsService, HSNCode, Quantity, 0, UOM, UnitPrice, TotalAmt, LineDiscountAmt, GSTBaseAmtLine,
//                                 GSTPer, SGSTAmtLine, CGSTAmtLine, IGSTAmtLine, TotalItemValue);
//                         until Item_SalesCreditMemoLine.Next() = 0;
//                 end;
//             DocumentType::"Transfer Shipment":
//                 begin
//                     Item_TranferShipmentLine.Reset();
//                     Item_TranferShipmentLine.SetRange("Document No.", DocNo);
//                     Item_TranferShipmentLine.SetFilter(Quantity, '<>%1', 0);
//                     Item_TranferShipmentLine.SetFilter("Item No.", '<>%1&<>%2', GLAccount_Round_1, GLAccount_Round_2);
//                     if Item_TranferShipmentLine.FindSet() then
//                         repeat
//                             SiNo += 1;
//                             ProductDesc := Item_TranferShipmentLine.Description;
//                             ProductDesc2 := Item_TranferShipmentLine."Description 2";
//                             IsService := 'N';
//                             HSNCode := Item_TranferShipmentLine."HSN/SAC Code";
//                             Quantity := abs(Item_TranferShipmentLine.Quantity);
//                             UnitofMeasure.RESET;
//                             UnitofMeasure.SETRANGE(Code, Item_TranferShipmentLine."Unit of Measure Code");
//                             IF UnitofMeasure.FINDFIRST THEN
//                                 UOM := UnitofMeasure."UOM For E Invoicing"
//                             ELSE
//                                 UOM := 'OTH';
//                             UnitPrice := abs(Item_TranferShipmentLine."Unit Price" / CuurencyFactor);
//                             TotalAmt := abs((Item_TranferShipmentLine.Quantity * Item_TranferShipmentLine."Unit Price") / CuurencyFactor);
//                             LineDiscountAmt := 0;
//                             GetGSTValueForLine(Item_TranferShipmentLine."Document No.", Item_TranferShipmentLine."Line No.", GSTBaseAmtLine, SGSTAmtLine, GSTPer,
//                                 CGSTAmtLine, IGSTAmtLine);

//                             TotalItemValue := abs(GSTBaseAmtLine + SGSTAmtLine + CGSTAmtLine + IGSTAmtLine);
//                             WriteItemList(JItemArray, SiNo, ProductDesc, ProductDesc2, IsService, HSNCode, Quantity, 0, UOM, UnitPrice, TotalAmt, LineDiscountAmt, GSTBaseAmtLine,
//                                 GSTPer, SGSTAmtLine, CGSTAmtLine, IGSTAmtLine, TotalItemValue);
//                         until Item_TranferShipmentLine.Next() = 0;
//                 end;
//         end;

//     end;

//     local procedure WriteItemList(var JWriteItemArray: JsonArray; SiNo: Integer; ProductDesc: Text[100]; ProductDesc2: Text[50]; IsService: Text[10];
//         HSNCode: Code[10]; Quantity: Decimal; FreeQuantity: Decimal; UOM: Code[10]; UnitPrice: Decimal; TotalAmt: Decimal; LineDiscountAmt: Decimal;
//         GSTBaseAmtLine: Decimal; GSTPer: Decimal; SGSTAmtLine: Decimal; CGSTAmtLine: Decimal; IGSTAmtLine: Decimal; TotalItemValue: Decimal)
//     var
//         JwriteItem: JsonObject;
//         JSonNull: JsonValue;
//     begin
//         JSonNull.SetValueToNull();
//         JwriteItem.Add('SiNo', format(SiNo));
//         JwriteItem.Add('ProductDesc', DelString(ProductDesc) + DelString(ProductDesc2));
//         JwriteItem.Add('IsService', IsService);
//         JwriteItem.Add('HsnCode', HSNCode);
//         JwriteItem.Add('BarCode', JSonNull);
//         JwriteItem.Add('Quantity', ReturnStr(RoundAmt(Quantity)));
//         JwriteItem.Add('FreeQuantity', 0);
//         JwriteItem.Add('Unit', UOM);
//         JwriteItem.Add('UnitPrice', ReturnStr(RoundAmt(UnitPrice)));
//         JwriteItem.Add('TotAmount', ReturnStr(RoundAmt(TotalAmt)));
//         JwriteItem.Add('Discount', ReturnStr(RoundAmt(LineDiscountAmt)));
//         JwriteItem.Add('PreTaxableVal', ReturnStr(RoundAmt(GSTBaseAmtLine)));
//         JwriteItem.Add('OtherCharges', 0);
//         JwriteItem.Add('AssAmount', ReturnStr(RoundAmt(GSTBaseAmtLine)));
//         JwriteItem.Add('GstRate', ReturnStr(RoundAmt(GSTPer)));
//         JwriteItem.Add('SgstAmt', ReturnStr(RoundAmt(SGSTAmtLine)));
//         JwriteItem.Add('CgstAmt', ReturnStr(RoundAmt(CGSTAmtLine)));
//         JwriteItem.Add('IgstAmt', ReturnStr(RoundAmt(IGSTAmtLine)));
//         JwriteItem.Add('CesRate', 0);
//         JwriteItem.Add('CessAmt', 0);
//         JwriteItem.Add('CesNonAdvalAmt', 0);
//         JwriteItem.Add('StateCesRate', 0);
//         JwriteItem.Add('StateCesAmt', 0);
//         JwriteItem.Add('TotItemVal', ReturnStr(RoundAmt(TotalItemValue)));
//         JwriteItem.Add('OrderLineRef', JSonNull);
//         JwriteItem.Add('OriginCountry', JSonNull);
//         JwriteItem.Add('ProdSerialNo', JSonNull);
//         JwriteItem.Add('TpApiAttribDtls', JSonNull);
//         JWriteItemArray.Add(JwriteItem);
//         Clear(JwriteItem);


//     end;

//     local procedure GetGSTValueForLine(DocNo: Code[20]; DocumentLineNo: Integer; var GSTBaeAmtLine: Decimal; var SGSTAmtline: Decimal; var GSTPer: Decimal; var CSGTAmtLine
//     : Decimal; var IGSTAmtLine: Decimal)
//     var
//         Item_DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
//     begin
//         Clear(GSTPer);
//         Clear(GSTBaeAmtLine);
//         Clear(IGSTAmtLine);
//         Clear(SGSTAmtline);
//         Clear(CSGTAmtLine);
//         Item_DetailedGSTLedgerEntry.Reset();
//         Item_DetailedGSTLedgerEntry.SetRange("Document No.", DocNo);
//         Item_DetailedGSTLedgerEntry.SetRange("Document Line No.", DocumentLineNo);
//         if Item_DetailedGSTLedgerEntry.FindSet() then
//             repeat
//                 if Item_DetailedGSTLedgerEntry."GST Component Code" = 'SGST' then begin
//                     GSTBaeAmtLine := abs(Item_DetailedGSTLedgerEntry."GST Base Amount");
//                     SGSTAmtline := abs(Item_DetailedGSTLedgerEntry."GST Amount");
//                     GSTPer += abs(Item_DetailedGSTLedgerEntry."GST %");
//                 end else
//                     if Item_DetailedGSTLedgerEntry."GST Component Code" = 'CGST' then begin
//                         CSGTAmtLine := abs(Item_DetailedGSTLedgerEntry."GST Amount");
//                         GSTPer += abs(Item_DetailedGSTLedgerEntry."GST %");
//                     end else
//                         if Item_DetailedGSTLedgerEntry."GST Component Code" = 'IGST' then begin
//                             GSTBaeAmtLine := abs(Item_DetailedGSTLedgerEntry."GST Base Amount");
//                             IGSTAmtLine := abs(Item_DetailedGSTLedgerEntry."GST Amount");
//                             GSTPer := abs(Item_DetailedGSTLedgerEntry."GST %");
//                         end;
//             until Item_DetailedGSTLedgerEntry.Next() = 0;
//     end;

//     local procedure GetTCSAmount(DocNo: Code[20]; DocLineNo: Integer; DocType: Integer): Decimal
//     var
//         SalesInvoiceLine: Record 113;
//         SalesCrMemoLine: Record 115;
//         TaxTranscValue: Record "Tax Transaction Value";
//         TCSSetup: Record "TCS Setup";
//     begin
//         CASE DocType OF
//             2:
//                 BEGIN
//                     SalesInvoiceLine.SETRANGE("Document No.", DocNo);
//                     SalesInvoiceLine.SETRANGE("Line No.", DocLineNo);
//                     IF SalesInvoiceLine.FINDFIRST THEN begin
//                         TCSSetup.Get();
//                         TaxTranscValue.Reset();
//                         TaxTranscValue.SetRange("Tax Record ID", SalesInvoiceLine.RecordId);
//                         TaxTranscValue.SetRange("Line No. Filter", SalesInvoiceLine."Line No.");
//                         TaxTranscValue.SetRange("Tax Type", TCSSetup."Tax Type");
//                         TaxTranscValue.SetRange("Value Type", TaxTranscValue."Value Type"::COMPONENT);
//                         TaxTranscValue.SetRange("Value ID", 6);
//                         if TaxTranscValue.FindFirst() then
//                             exit(TaxTranscValue.Amount);
//                     end;
//                 END;
//             3:
//                 BEGIN
//                     SalesCrMemoLine.SETRANGE("Document No.", DocNo);
//                     SalesCrMemoLine.SETRANGE("Line No.", DocLineNo);
//                     IF SalesCrMemoLine.FINDFIRST THEN begin
//                         TCSSetup.Get();
//                         TaxTranscValue.Reset();
//                         TaxTranscValue.SetRange("Tax Record ID", SalesCrMemoLine.RecordId);
//                         TaxTranscValue.SetRange("Line No. Filter", SalesCrMemoLine."Line No.");
//                         TaxTranscValue.SetRange("Tax Type", TCSSetup."Tax Type");
//                         TaxTranscValue.SetRange("Value Type", TaxTranscValue."Value Type"::COMPONENT);
//                         TaxTranscValue.SetRange("Value ID", 6);
//                         if TaxTranscValue.FindFirst() then
//                             exit(TaxTranscValue.Amount);
//                     end;
//                 END;
//         END;
//     end;


//     local procedure DelString(StringToChange: Text): Text
//     var
//         CharToRemove: Char;
//         ASCIIVal: Integer;
//         i: Integer;
//         FinalString: Text;
//     begin
//         CLEAR(FinalString);
//         StringToChange := DELCHR(StringToChange, '=', '\');
//         StringToChange := DELCHR(StringToChange, '=', '–');
//         StringToChange := DELCHR(StringToChange, '=', '"');
//         StringToChange := DELCHR(StringToChange, '=', '^');
//         StringToChange := DELCHR(StringToChange, '=', '”');
//         StringToChange := DELCHR(StringToChange, '=', '"');
//         StringToChange := DELCHR(StringToChange, '=', '’');
//         StringToChange := DELCHR(StringToChange, '=', '’');
//         FOR i := 1 TO STRLEN(StringToChange) DO BEGIN
//             CharToRemove := StringToChange[i];
//             ASCIIVal := CharToRemove;
//             IF (STRPOS('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 @%(),-./', FORMAT(StringToChange[i])) > 0) AND (ASCIIVal <> 160) THEN
//                 FinalString += FORMAT(StringToChange[i])
//             ELSE
//                 FinalString += ' ';
//         END;
//         EXIT(FinalString);
//     end;

//     local procedure ReturnStr(Amt: Decimal): Text
//     begin
//         EXIT(DELCHR(FORMAT(Amt), '=', ','));
//     end;

//     local procedure RoundAmt(Amt: Decimal): Decimal
//     var
//     begin
//         exit(Round(Amt, 0.01, '='))
//     end;
// }
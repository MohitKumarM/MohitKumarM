codeunit 50000 "Auth 2.0"
{
    trigger OnRun()
    var
        Jsonheader: JsonObject;
        Jsonheader1: JsonObject;
        BodyText: Text;
    begin
        ReadDocDtls(Jsonheader);
        ReadExpDtls(Jsonheader1);
        Jsonheader.Add('Exp', Jsonheader1);

        Jsonheader.WriteTo(BodyText);
        Message(BodyText);
    end;

    procedure GetAccessToken() Token: Text
    var
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;

        JResultToken: JsonToken;
        JResultObject: JsonObject;

        ResultMessage: Text;
        TokenRequestbody: Text;

    begin
        Clear(EinvoiceHttpContent);
        Clear(EinvoiceHttpHeader);
        Clear(EinvoiceHttpRequest);
        Clear(EinvoiceHttpClient);
        Clear(ResultMessage);
        Clear(JResultObject);
        Clear(JResultToken);
        Clear(EinvoiceHttpResponse);
        Clear(EinvoiceHttpContent);
        Clear(EinvoiceHttpHeader);
        Clear(EinvoiceHttpRequest);
        Clear(EinvoiceHttpClient);
        Clear(ResultMessage);
        Clear(JResultObject);
        Clear(JResultToken);
        Clear(EinvoiceHttpResponse);
        TokenRequestbody := 'grant_type=Client_Credentials&client_id=fa7e3cb6-60be-4d54-b515-81173f58d31e&client_secret=1FM8Q~ywhdiC39l2Rwy3yEqmhYVyJwlBWwlhub6e&Scope=https://api.businesscentral.dynamics.com/.default';
        EinvoiceHttpContent.WriteFrom(TokenRequestbody);
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();

        EinvoiceHttpHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        EinvoiceHttpHeader.Add('Return-Type', 'application/text');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri('https://login.microsoftonline.com/d3a55687-ec5c-433b-9eaa-9d952c913e94/oauth2/v2.0/token');
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);

            if JResultObject.Get('access_token', JResultToken) then
                evaluate(Token, JResultToken.AsValue().AsText());
        end;
    end;

    procedure TestAut20()
    var
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        ResultMessage: Text;
        JsonBody: JsonObject;
        JsonText: Text;
        Token: Text;
    begin
        Token := 'Bearer' + ' ' + GetAccessToken();
        Message(Token);
        JsonBody.Add('documentNo', 'PI104774');
        JsonBody.WriteTo(JsonText);
        Message(JsonText);
        EinvoiceHttpContent.WriteFrom(JsonText);
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', Token);
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri('https://api.businesscentral.dynamics.com/v2.0/d3a55687-ec5c-433b-9eaa-9d952c913e94/Production/ODataV4/DocumentsAttachment_DocumentsAttachmentFile?company=FICCI');
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message(ResultMessage);
            if JResultObject.Get('value', JResultToken) then
                Message('%1', JResultToken.AsValue().AsText());
        end else
            Message(GetLastErrorText());
    end;

    procedure GetAccessToken2() Token: Text
    var
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;

        JResultToken: JsonToken;
        JResultObject: JsonObject;

        ResultMessage: Text;
        TokenRequestbody: Text;
        textLabel: Text;
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
        UserName: Text;
        Password: Text;
    begin
        textLabel := ' ';
        Clear(EinvoiceHttpContent);
        Clear(EinvoiceHttpHeader);
        Clear(EinvoiceHttpRequest);
        Clear(EinvoiceHttpClient);
        Clear(ResultMessage);
        Clear(JResultObject);
        Clear(JResultToken);
        Clear(EinvoiceHttpResponse);
        Clear(EinvoiceHttpContent);
        Clear(EinvoiceHttpHeader);
        Clear(EinvoiceHttpRequest);
        Clear(EinvoiceHttpClient);
        Clear(ResultMessage);
        Clear(JResultObject);
        Clear(JResultToken);
        Clear(EinvoiceHttpResponse);
        TokenRequestbody := 'grant_type=client_credentials';

        EinvoiceHttpContent.WriteFrom(TokenRequestbody);
        EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        EinvoiceHttpHeader.Clear();
        UserName := 'W70gribCPaum0Hh431PWpsomkh1jAKWWBWNawnlQFi8Xl1Q7';
        Password := '2foGPbfMg8juEcGAX4uS2rLcSrSoy90fNZpOrGLcdY4ZHBOI2hzGfnKfYOxErSTB';
        AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        AuthString := Base64Helpers.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);

        EinvoiceHttpClient.DefaultRequestHeaders.Add('Authorization', AuthString);
        EinvoiceHttpHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        EinvoiceHttpRequest.SetRequestUri('https://wwwcie.ups.com/security/v1/oauth/token');
        EinvoiceHttpRequest.Method := 'POST';
        if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
            EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);
            Message(ResultMessage);
            if JResultObject.Get('access_token', JResultToken) then
                evaluate(Token, JResultToken.AsValue().AsText());
        end;
    end;

    procedure AddHttpBasicAuthHeader(UserName: Text[50]; Password: Text[50]; var HttpClient: HttpClient);
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
        AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        AuthString := Base64Helpers.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
    end;

    local procedure WriteDocDtls(Typ: Text[3]; No: Text[16]; Dt: Text[10]; OrgInvNo: Text[16]; var JWriteDocObject: JsonObject)
    var
    begin
        JWriteDocObject.Add('docType', Typ);
        JWriteDocObject.Add('docNo', No);
        JWriteDocObject.Add('docDate', Dt);
    end;

    local procedure ReadDocDtls(var JReadDetails: JsonObject)
    var
        Typ: Text[3];
        Dt: Text[10];
        OrgInvNo: Text[16];
    begin
        Typ := 'INV';
        Dt := '05102023';
        OrgInvNo := '100';

        WriteDocDtls(Typ, '100', Dt, OrgInvNo, JReadDetails);

        // OrgInvNo := 'InvTest0018';
        // WriteDocDtls(Typ,COPYSTR('InvTest0018',1,16),Dt,OrgInvNo);
    end;

    local procedure ReadExpDtls(var JsonReadDetails: JsonObject)
    var
        SalesInvoiceLine: Record 113;
        SalesCrMemoLine: Record 115;
        // GSTManagement: Codeunit 16401;
        ExpCat: Text[3];
        WithPay: Text[1];
        ShipBNo: Text[16];
        ShipBDt: Text[10];
        Port: Text[10];
        InvForCur: Decimal;
        ForCur: Text[3];
        CntCode: Text[2];
        GSTBaseAmt: Decimal;
        GSTAmt: Decimal;
    begin
        ExpCat := 'Te';
        WithPay := 'T';
        ShipBNo := 'TestShip';
        ShipBDt := 'TestBt';
        Port := 'Tes';
        InvForCur := 0;
        ForCur := '5';
        CntCode := '7';
        WriteExpDtls(ExpCat, WithPay, ShipBNo, ShipBDt, Port, InvForCur, ForCur, CntCode, JsonReadDetails);
    end;

    local procedure WriteExpDtls(ExpCat: Text[3]; WithPay: Text[1]; ShipBNo: Text[16]; ShipBDt: Text[10]; Port: Text[10]; InvForCur: Decimal; ForCur: Text[3]; CntCode: Text[2]; var JHeaderObject: JsonObject)
    var
        JGlobalNull: JsonValue;
    begin
        JGlobalNull.SetValueToNull();
        if ShipBNo <> '' then
            JHeaderObject.Add('shippingBillNo', ShipBNo)
        else
            JHeaderObject.Add('shippingBillNo', JGlobalNull);
        if ShipBDt <> '' then
            JHeaderObject.Add('shippingBillDate', ShipBDt)
        else
            JHeaderObject.Add('shippingBillDate', JGlobalNull);
        if CntCode <> '' then
            JHeaderObject.Add('countryCode', CntCode)
        else
            JHeaderObject.Add('countryCode', JGlobalNull);

        IF ForCur <> '' THEN
            JHeaderObject.add('foreignCurrency', ForCur)
        ELSE
            JHeaderObject.Add('foreignCurrency', JGlobalNull);
        JHeaderObject.Add('invValueFc', InvForCur);
        if Port <> '' then
            JHeaderObject.Add('portCode', Port)
        else
            JHeaderObject.Add('portCode', JGlobalNull);
    end;

    // Codeunit18543 Start
    [EventSubscriber(ObjectType::Codeunit, 18543, 'OnAfterValidatePurchaseLineFields', '', false, false)]
    procedure OnAfterValidatePurchaseLineFields(var PurchaseLine: Record "Purchase Line")
    var
        Purchaseheader: Record "Purchase Header";
        DateFilterCalc: Codeunit "DateFilter-Calc";
        AccountingPeriodFilter: Text[30];
        AccountingPeriodFilter2: Text[30];
        PurchInvAmt_TDS: Decimal;
        PurchCrMemoAmt_TDS: Decimal;
        NewTDSBaseAmount: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        TDSSetup: Record "TDS Setup";
        LineC: Integer;
        Team002: Label 'Previous Purchase amount of PAN %1 is %2.';
        LineAmount: Decimal;
        RecPurchaseLine: Record "Purchase Line";
        PreviousTDSAmount: Decimal;
    begin
        if Purchaseheader.get(PurchaseLine."Document Type", PurchaseLine."Document No.") then;
        if (Purchaseheader."Document Type" = Purchaseheader."Document Type"::Order) or (Purchaseheader."Document Type" = Purchaseheader."Document Type"::Invoice) then begin
            if (PurchaseLine."TDS Section Code" = '194C') and (PurchaseLine."GST Group Type" = PurchaseLine."GST Group Type"::Goods) then begin
                DateFilterCalc.CreateAccountingPeriodFilter(AccountingPeriodFilter, AccountingPeriodFilter2, Purchaseheader."Posting Date", 0);
                CalculatePANWisePurchase(PurchaseLine, AccountingPeriodFilter, PurchaseLine."P.A.N. No.", PurchInvAmt_TDS, PurchCrMemoAmt_TDS);//TradingTDSCalc
                PreviousTDSAmount := PurchInvAmt_TDS - PurchCrMemoAmt_TDS;
                LineAmount := 0;
                RecPurchaseLine.Reset();
                RecPurchaseLine.SetRange("Document No.", PurchaseLine."Document No.");
                if RecPurchaseLine.FindSet() then
                    repeat
                        LineAmount += RecPurchaseLine."Line Amount";
                    until RecPurchaseLine.next = 0;
                PreviousTDSAmount += LineAmount;
                LineC += 1;
                IF LineC = 1 THEN
                    MESSAGE(Team002, PurchaseLine."P.A.N. No.", PreviousTDSAmount);
                if PreviousTDSAmount > 5000000 then
                    NewTDSBaseAmount := abs(5000000 - PurchaseLine."Line Amount")
                else
                    NewTDSBaseAmount := PurchaseLine."Line Amount";

                TDSSetup.Get();
                if PurchaseLine.Type <> PurchaseLine.Type::" " then begin
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
                    TaxTransactionValue.SetRange("Document Type Filter", PurchaseLine."Document Type"::Invoice);
                    TaxTransactionValue.SetRange("Document No. Filter", PurchaseLine."Document No.");
                    TaxTransactionValue.SetRange("Line No. Filter", PurchaseLine."Line No.");
                    TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindFirst() then begin
                        TaxTransactionValue.Amount := (NewTDSBaseAmount * TaxTransactionValue.Percent) / 100;
                        TaxTransactionValue.Modify();
                    end;
                end;
                if PurchaseLine.Type <> PurchaseLine.Type::" " then begin
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
                    TaxTransactionValue.SetRange("Document Type Filter", PurchaseLine."Document Type"::Invoice);
                    TaxTransactionValue.SetRange("Document No. Filter", PurchaseLine."Document No.");
                    TaxTransactionValue.SetRange("Line No. Filter", PurchaseLine."Line No.");
                    TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetRange("Value ID", 8);
                    if TaxTransactionValue.FindFirst() then begin
                        TaxTransactionValue.Amount := NewTDSBaseAmount;

                        TaxTransactionValue.Modify();
                    end;
                end;
                Message(Format(NewTDSBaseAmount));

            end;
        end;
    end;

    procedure CalculatePANWisePurchase(PurchaseLine: Record "Purchase Line"; AccPeriodFilter: Text[30]; Pay2VendPAN: Code[20]; var PrevPurchInvoiceAmount: Decimal; var PrevPurchCreditMemoAmount: Decimal)
    var
        PurchInvLineR: Record "Purch. Inv. Line";
        PurchCrMemoLineR: Record "Purch. Cr. Memo Line";
    begin
        //TradingTDSCalc
        PurchInvLineR.RESET;
        PurchInvLineR.SETCURRENTKEY("Posting Date", "P.A.N. No.", Type);
        PurchInvLineR.SetRange("Posting Date", 20230401D, 20240331D);
        PurchInvLineR.SETFILTER("P.A.N. No.", Pay2VendPAN);
        PurchInvLineR.SETFILTER(Type, '%1|%2', PurchInvLineR.Type::Item, PurchInvLineR.Type::"Charge (Item)");
        PurchInvLineR.CALCSUMS("Line Amount", "Line Discount Amount");
        PrevPurchInvoiceAmount := ABS(PurchInvLineR."Line Amount") - ABS(PurchInvLineR."Line Discount Amount");
        PurchCrMemoLineR.RESET;
        PurchCrMemoLineR.SETCURRENTKEY("Posting Date", "P.A.N. No.", Type);
        PurchCrMemoLineR.SETFILTER("Posting Date", AccPeriodFilter);
        PurchCrMemoLineR.SETFILTER("P.A.N. No.", Pay2VendPAN);
        PurchCrMemoLineR.SETFILTER(Type, '%1|%2', PurchCrMemoLineR.Type::Item, PurchCrMemoLineR.Type::"Charge (Item)");
        PurchCrMemoLineR.CALCSUMS("Line Amount", "Line Discount Amount");
        PrevPurchCreditMemoAmount := ABS(PurchCrMemoLineR."Line Amount") - ABS(PurchCrMemoLineR."Line Discount Amount");
    end;
    // Codeunit18543 Start

}
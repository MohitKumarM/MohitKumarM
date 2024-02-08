page 50111 "ZY HyperLink"
{
    Extensible = false;
    Caption = 'HyperLink';
    Editable = false;
    PageType = Card;
    layout
    {
        area(content)
        {
            group(Control5)
            {
                ShowCaption = false;
            }
            usercontrol(WebPageViewer; "Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = All;
                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    CurrPage.WebPageViewer.Navigate(URL);
                end;

                trigger Callback(data: Text)
                begin
                    CurrPage.Close();
                end;
            }
        }
    }
    var
        URL: Text;

    procedure SetURL(NavigateToURL: Text)
    begin
        URL := NavigateToURL;
    end;
}
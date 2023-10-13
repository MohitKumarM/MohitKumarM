pageextension 50003 MyExtension extends "Email Editor"
{
    layout
    {
        modify(Account)
        {
            Editable = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
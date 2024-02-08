tableextension 50056 Custom extends Customer
{
    fields
    {
        field(50000; "Skip Tcs"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}
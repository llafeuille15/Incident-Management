pageextension 50105 "Business Manager RC Incident" extends "Business Manager Role Center"
{
    actions
    {
        addafter("Chart of Accounts")
        {
            action(IncidentList)
            {
                Caption = 'Incident';
                ApplicationArea = All;
                RunObject = Page "Incident List";
                Image = Warning;
            }
        }
    }
}
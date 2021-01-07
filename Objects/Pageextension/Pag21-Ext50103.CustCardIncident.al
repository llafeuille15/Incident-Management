pageextension 50103 "Cust. Card Incident" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group(Incident)
            {
                Caption = 'Incident';

                field("No. of Incidents"; "No. of Incidents")
                {
                    Caption = 'No. of Incidents';
                    ApplicationArea = All;
                }
            }
        }
    }
}
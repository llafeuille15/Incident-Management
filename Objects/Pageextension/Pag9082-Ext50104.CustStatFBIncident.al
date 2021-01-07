pageextension 50104 "Cust. Stat. FB Incident" extends "Customer Statistics FactBox"
{
    layout
    {
        addlast(Sales)
        {
            field("No. of Incidents"; rec."No. of Incidents")
            {
                Caption = 'No. of Incidents';
                ApplicationArea = All;
            }
        }
    }
}
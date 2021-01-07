tableextension 50100 "Customer Incident" extends Customer
{
    fields
    {
        field(50100; "No. of Incidents"; Integer)
        {
            Caption = 'No. of Incidents';
            FieldClass = FlowField;
            CalcFormula = count (Incident where ("Customer No." = field ("No.")));
            Editable = false;
        }
    }
}
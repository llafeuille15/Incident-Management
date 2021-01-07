query 50100 "Incident by Year"
{
    Caption = 'Incident by Year';
    QueryType = Normal;

    elements
    {
        dataitem(Incident; Incident)
        {
            column(Year; Date)
            {
                Caption = 'Year';
                Method = Year;
            }
            column(NoOfIncidents)
            {
                Caption = 'No. of Incidents';
                Method = Count;
            }
        }
    }
}
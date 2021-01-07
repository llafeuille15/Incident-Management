xmlport 50100 "Import/Export Incident"
{
    Caption = 'Import/Export Incident';
    Direction = Both;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    Format = Xml;

    schema
    {
        textelement(Incidents)
        {
            tableelement(Incident; Incident)
            {
                AutoReplace = true;
                AutoSave = true;
                AutoUpdate = true;

                fieldelement(EntryNo; Incident."Entry No.")
                {

                }
                fieldelement(CustomerNo; Incident."Customer No.")
                {

                }
                fieldelement(Date; Incident.Date)
                {

                }
                /*
                fieldelement(Type; Incident.Type)
                {

                }
                */
                fieldelement(DurationHours; Incident."Duration (Hours)")
                {

                }
                fieldelement(Comment; Incident.Comment)
                {

                }
                fieldelement(GPSCoordinatesDecDegrees; Incident."GPS Coordinates (dec. degrees)")
                {

                }
                fieldelement(BarCode; Incident."Bar Code")
                {

                }
            }
        }
    }
}
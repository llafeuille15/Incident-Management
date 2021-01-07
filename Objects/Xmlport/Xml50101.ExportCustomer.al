xmlport 50101 "Export Customer"
{
    Caption = 'Export Customer';
    Direction = Export;
    TextEncoding = UTF8;
    FormatEvaluate = Legacy;
    Format = VariableText;

    schema
    {
        textelement(Customers)
        {
            tableelement(Customer; Customer)
            {
                CalcFields = "No. of Incidents";

                fieldelement(No; Customer."No.")
                {

                }
                fieldelement(Name; Customer.Name)
                {

                }
                fieldelement(NoOfIncidents; Customer."No. of Incidents")
                {

                }
            }
        }
    }
}
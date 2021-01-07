report 50100 "Incident - List"
{
    Caption = 'Incident List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './Objects/Report/Rep50100.IncidentList.docx';

    dataset
    {
        dataitem(Incident; Incident)
        {
            RequestFilterFields = "Customer No.", "Date";

            column(CompanyPropertyDisplayName; CompanyProperty.DisplayName()) { }
            column(TableCaptionIncidentFilter; TableCaption() + ': ' + IncidentFilter) { }
            column(IncidentFilter; IncidentFilter) { }
            column(IncidentListCaptionLbl; IncidentListCaptionLbl) { }
            column(CustomerNo; "Customer No.") { }
            column(CustomerNoCaption; FieldCaption("Customer No.")) { }
            column(Date; Date) { }
            column(DateCaption; FieldCaption(Date)) { }
            //column(Type; Type) { }
            //column(TypeCaption; FieldCaption(Type)) { }
            column(Comment; Comment) { }
            column(CommentCaption; FieldCaption(Comment)) { }
        }
    }

    trigger OnPreReport();
    begin
        IncidentFilter := CaptionMgt.GetRecordFiltersWithCaptions(Incident);
    end;

    var
        CaptionMgt: Codeunit "Format Document";
        IncidentFilter: Text;
        IncidentListCaptionLbl: Label 'Incident - List', Locked = false, MaxLength = 250;
}
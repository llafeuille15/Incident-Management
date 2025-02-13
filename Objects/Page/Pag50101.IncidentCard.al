page 50101 "Incident Card"
{
    caption = 'Incident Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Incident";

    layout
    {
        area(Content)
        {
            group(General)
            {
                caption = 'General';
                field("Entry No."; Rec."Entry No.")
                {
                    caption = 'Entry No.';
                    Visible = false;
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    caption = 'Customer No.';
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    caption = 'Date';
                    ApplicationArea = All;
                }
            }
            group(Incident)
            {
                caption = 'Incident';
                field(Type; Rec.Type)
                {
                    caption = 'Type';
                    ApplicationArea = All;
                }
                field("Duration (Hours)"; Rec."Duration (Hours)")
                {
                    caption = 'Duration (Hours)';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    caption = 'Comment';
                    ApplicationArea = All;
                }
                field(Picture; Rec.Picture)
                {
                    caption = 'Picture';
                    ApplicationArea = All;
                }

                field("GPS Coordinates (dec. degrees)"; Rec."GPS Coordinates (dec. degrees)")
                {
                    caption = 'GPS Coordinates (dec. degrees)';
                    ApplicationArea = All;
                }
                field("QR Code"; Rec."QR Code")
                {
                    caption = 'QR Code';
                    ApplicationArea = All;
                }
                field("Bar Code"; Rec."Bar Code")
                {
                    caption = 'Bar Code';
                    ApplicationArea = All;
                }
            }
        }

        area(Factboxes)
        {
            part(IncidentPicture; 50102)
            {
                caption = 'Incident Picture';
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No.");
            }
            part(IncidentQRCode; 50104)
            {
                caption = 'Incident QR Code';
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No.");
            }
            part(CustomerStatisticsFactBox; 9082)
            {
                caption = 'Customer Statistics';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Customer No.");
            }
        }
    }
}
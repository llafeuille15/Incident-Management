page 50100 "Incident List"
{
    caption = 'Incident List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    CardPageId = "Incident Card";
    RefreshOnActivate = true;
    SourceTable = "Incident";
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    caption = 'Entry No.';
                    Visible = false;
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
            part(CustomerStatisticsFactBox; 9082)
            {
                caption = 'Customer Statistics';
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("Customer No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Export)
            {
                Caption = 'Export';
                ApplicationArea = All;
                Image = Export;
                Promoted = true;

                trigger OnAction();
                var
                    TempBlob: record TempBlob temporary;
                    MyOutStream: OutStream;
                    MyInStream: InStream;
                    FileName: Text;
                begin
                    TempBlob.Blob.CreateOutStream(MyOutStream);
                    Xmlport.Export(Xmlport::"Import/Export Incident", MyOutStream);
                    TempBlob.Blob.CreateInStream(MyInStream);
                    FileName := TableCaption() + '.xml';
                    DownloadFromStream(MyInStream, '', '', '', FileName);
                end;
            }
            action(Import)
            {
                Caption = 'Import';
                ApplicationArea = All;
                Image = Import;
                Promoted = true;

                trigger OnAction();
                var
                    FromFilterLbl: Label 'XML Files (*.xml)|*.xml', Locked = false, MaxLength = 250;
                    FromFileName: Text;
                    MyInStream: InStream;
                begin
                    if UploadIntoStream('', '', FromFilterLbl, FromFileName, MyInStream) then
                        Xmlport.Import(Xmlport::"Import/Export Incident", MyInStream);
                end;
            }

            action("Cause Error")
            {
                Caption = 'Cause Error';
                ApplicationArea = All;
                Image = Error;
                Promoted = true;

                trigger OnAction()
                var
                    IncidentError: Codeunit "Incident - Error";
                begin
                    IncidentError.Run(Rec);
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                RunObject = report "Incident - List";
            }
        }
    }
}
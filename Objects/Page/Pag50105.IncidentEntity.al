page 50105 "Incident Entity"
{
    PageType = API;
    Caption = 'incidents', Locked = true;
    APIPublisher = 'prodware';
    APIGroup = 'incident';
    APIVersion = 'beta';
    EntityName = 'incident';
    EntitySetName = 'incidents';
    SourceTable = Incident;
    DelayedInsert = true;
    ODataKeyFields = Id;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.Id)
                {
                    Caption = 'id', Locked = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'entryNo', Locked = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'customerNo', Locked = true;
                    ApplicationArea = All;
                }
                field(date; Rec.Date)
                {
                    Caption = 'date', Locked = true;
                    ApplicationArea = All;
                }
                field(type; rec.Type)
                {
                    Caption = 'type', Locked = true;
                    ApplicationArea = All;
                }
                field(durationHours; Rec."Duration (Hours)")
                {
                    Caption = 'durationHours', Locked = true;
                    ApplicationArea = All;
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'comment', Locked = true;
                    ApplicationArea = All;
                }
                field(gpsCoordinatesDecDegrees; Rec."GPS Coordinates (dec. degrees)")
                {
                    Caption = 'gpsCoordinatesDecDegrees', Locked = true;
                    ApplicationArea = All;
                }
                field(barCode; Rec."Bar Code")
                {
                    Caption = 'barCode', Locked = true;
                    ApplicationArea = All;
                }
                field(picture; PictureBase64)
                {
                    Caption = 'picture', Locked = true;
                    ApplicationArea = All;
                }
                field(qrCode; QRCodeBase64)
                {
                    Caption = 'qrCode', Locked = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        PictureBase64: text;
        QRCodeBase64: text;

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Insert(true);
        Rec.SetPictureFromBase64(PictureBase64);
        Rec.SetQRCodeFromBase64(QRCodeBase64);

        SetCalculatedFields();
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        Incident: record Incident;
    begin
        Incident.SetRange(Id, Rec.Id);
        Incident.FindFirst();

        if Rec."Entry No." = Incident."Entry No." then
            Rec.modify(true)
        else begin
            Incident.TransferFields(Rec, false);
            Incident.Rename(Rec."Entry No.");
            Rec.TransferFields(Incident, true);
        end;

        SetCalculatedFields();
        exit(false);
    end;

    local procedure SetCalculatedFields()
    begin
        PictureBase64 := Rec.GetPictureAsBase64();
        QRCodeBase64 := Rec.GetQRCodeAsBase64();
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(Rec.Id);
        Clear(PictureBase64);
        Clear(QRCodeBase64);
    end;
}
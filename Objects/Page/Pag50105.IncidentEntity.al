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
                field(id; Id)
                {
                    Caption = 'id', Locked = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field(entryNo; "Entry No.")
                {
                    Caption = 'entryNo', Locked = true;
                    Editable = false;
                    ApplicationArea = All;
                }
                field(customerNo; "Customer No.")
                {
                    Caption = 'customerNo', Locked = true;
                    ApplicationArea = All;
                }
                field(date; Date)
                {
                    Caption = 'date', Locked = true;
                    ApplicationArea = All;
                }
                field(type; Type)
                {
                    Caption = 'type', Locked = true;
                    ApplicationArea = All;
                }
                field(durationHours; "Duration (Hours)")
                {
                    Caption = 'durationHours', Locked = true;
                    ApplicationArea = All;
                }
                field(comment; Comment)
                {
                    Caption = 'comment', Locked = true;
                    ApplicationArea = All;
                }
                field(gpsCoordinatesDecDegrees; "GPS Coordinates (dec. degrees)")
                {
                    Caption = 'gpsCoordinatesDecDegrees', Locked = true;
                    ApplicationArea = All;
                }
                field(barCode; "Bar Code")
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
        Insert(true);
        SetPictureFromBase64(PictureBase64);
        SetQRCodeFromBase64(QRCodeBase64);

        SetCalculatedFields();
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        Incident: record Incident;
    begin
        Incident.SetRange(Id, Id);
        Incident.FindFirst();

        if "Entry No." = Incident."Entry No." then
            modify(true)
        else begin
            Incident.TransferFields(Rec, false);
            Incident.Rename("Entry No.");
            TransferFields(Incident, true);
        end;

        SetCalculatedFields();
        exit(false);
    end;

    local procedure SetCalculatedFields()
    begin
        PictureBase64 := GetPictureAsBase64();
        QRCodeBase64 := GetQRCodeAsBase64();
    end;

    local procedure ClearCalculatedFields()
    begin
        Clear(Id);
        Clear(PictureBase64);
        Clear(QRCodeBase64);
    end;
}
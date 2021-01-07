table 50100 Incident
{
    Caption = 'Incident';
    LookupPageId = "Incident List";
    DrillDownPageId = "Incident List";
    DataCaptionFields = "Customer No.", Date;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(11; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(21; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(31; Type; Enum "Incident Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(41; "Duration (Hours)"; Decimal)
        {
            Caption = 'Duration (Hours)';
            DataClassification = CustomerContent;
        }
        field(51; Comment; Text[30])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(61; Picture; MediaSet)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(71; "GPS Coordinates (dec. degrees)"; text[50])
        {
            Caption = 'GPS Coordinates (dec. degrees)';
            DataClassification = CustomerContent;
        }
        field(81; "QR Code"; Media)
        {
            Caption = 'QR Code';
            DataClassification = CustomerContent;
        }
        field(91; "Bar Code"; Code[20])
        {
            Caption = 'Bar Code';
            DataClassification = CustomerContent;
        }
        field(8000; Id; Guid)
        {
            Caption = 'Id', Locked = true;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        Key(Key2; "Customer No.", Date)
        {

        }
        Key(Key3; Id)
        {

        }
    }

    trigger OnInsert()
    begin
        Id := CreateGuid();
    end;

    procedure GetPictureAsBase64(): Text
    var
        TenantMedia: record "Tenant Media";
        MediaMgt: Codeunit "Media Mgt.";
        PictureInStream: InStream;
    begin
        if Picture.Count() = 0 then
            exit('');

        TenantMedia.Get(Picture.Item(1));
        TenantMedia.CalcFields(Content);
        if TenantMedia.Content.HasValue() then begin
            TenantMedia.Content.CreateInStream(PictureInStream);
            exit(MediaMgt.ConvertInStreamToText(PictureInStream));
        end;

        exit('');
    end;

    procedure SetPictureFromBase64(PictureBase64: Text)
    var
        MediaMgt: Codeunit "Media Mgt.";
        PictureInStream: InStream;
        FileExtension: Text;
    begin
        if PictureBase64 = '' then
            exit;

        MediaMgt.ConvertTextToInStream(PictureBase64, PictureInStream, FileExtension);

        clear(Picture);
        Picture.ImportStream(PictureInStream, format("Entry No.") + '_Picture' + FileExtension);
        Modify(true);
    end;

    procedure GetQRCodeAsBase64(): Text
    var
        TenantMedia: record "Tenant Media";
        MediaMgt: Codeunit "Media Mgt.";
        QRCodeInStream: InStream;
    begin
        if not ("QR Code".HasValue()) then
            exit('');

        TenantMedia.Get("QR Code".MediaId());
        TenantMedia.CalcFields(Content);
        if TenantMedia.Content.HasValue() then begin
            TenantMedia.Content.CreateInStream(QRCodeInStream);
            exit(MediaMgt.ConvertInStreamToText(QRCodeInStream));
        end;

        exit('');
    end;

    procedure SetQRCodeFromBase64(QRCodeBase64: Text)
    var
        MediaMgt: Codeunit "Media Mgt.";
        QRCodeInStream: InStream;
        FileExtension: Text;
    begin
        if QRCodeBase64 = '' then
            exit;

        MediaMgt.ConvertTextToInStream(QRCodeBase64, QRCodeInStream, FileExtension);

        clear("QR Code");
        "QR Code".ImportStream(QRCodeInStream, format("Entry No.") + '_QRCode' + FileExtension);
        Modify(true);
    end;
}
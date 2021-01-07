page 50104 "Incident QR Code"
{
    Caption = 'Incident QR Code';
    PageType = CardPart;
    SourceTable = Incident;
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            field("QR Code"; Rec."QR Code")
            {
                Caption = 'QR Code';
                ShowCaption = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                Caption = 'Import';
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                begin
                    ImportFromDevice();
                end;
            }
            action(Export)
            {
                Caption = 'Export';
                Enabled = DeleteExportEnabled;
                ApplicationArea = All;
                Image = Export;

                trigger OnAction()
                begin
                    ExportToDevice();
                end;
            }
            action(Delete)
            {
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                begin
                    DeleteIncidentQRCode();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnQRCodeActions();
    end;

    var
        DeleteExportEnabled: Boolean;

    local procedure SetEditableOnQRCodeActions()
    begin
        DeleteExportEnabled := "QR Code".HasValue();
    end;

    procedure ImportFromDevice()
    var
        OverrideQRCodeQst: Label 'The existing QR Code will be replaced. Do you want to continue?', Locked = false, MaxLength = 250;
        DialogTitleLbl: Label 'Import', Locked = false, MaxLength = 250;
        FromFilterLbl: Label 'All Files (*.*)|*.*', Locked = false, MaxLength = 250;
        QRCodeInStream: InStream;
        FromFileName: Text;
    begin
        if "QR Code".HasValue() then
            if not Confirm(OverrideQRCodeQst) then
                exit;

        if UploadIntoStream(DialogTitleLbl, '', FromFilterLbl, FromFileName, QRCodeInStream) then begin
            Clear("QR Code");
            "QR Code".ImportStream(QRCodeInStream, FromFileName);
            Modify(true);
        end;
    end;

    procedure ExportToDevice()
    var
        TenantMedia: Record "Tenant Media";
        QRCodeLbl: Label '_QRCode', Locked = true, MaxLength = 250;
        QRCodeInStream: InStream;
        FileName: Text;
    begin
        if not ("QR Code".HasValue()) then
            exit;

        if TenantMedia.Get("QR Code".MediaId()) then begin
            TenantMedia.calcfields(Content);
            if TenantMedia.Content.HasValue() then begin
                FileName := TableCaption() + QRCodeLbl + GetTenantMediaFileExtension(TenantMedia);
                TenantMedia.Content.CreateInStream(QRCodeInStream);
                DownloadFromStream(QRCodeInStream, '', '', '', FileName);
            end;
        end;
    end;

    procedure DeleteIncidentQRCode()
    var
        DeleteQRCodeQst: Label 'Are you sure you want to delete the QR Code?', Locked = false, MaxLength = 250;
    begin
        IF NOT CONFIRM(DeleteQRCodeQst) THEN
            EXIT;

        CLEAR("QR Code");
        MODIFY(TRUE);
    end;

    local procedure GetTenantMediaFileExtension(var TenantMedia: Record "Tenant Media"): Text;
    begin
        case TenantMedia."Mime Type" of
            'image/jpeg':
                exit('.jpg');
            'image/png':
                exit('.png');
            'image/bmp':
                exit('.bmp');
            'image/gif':
                exit('.gif');
            'image/tiff':
                exit('.tiff');
            'image/wmf':
                exit('.wmf');
            else
                exit('.jpg');
        end;
    end;
}
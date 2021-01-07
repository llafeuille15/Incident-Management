page 50102 "Incident Picture"
{
    Caption = 'Incident Picture';
    PageType = CardPart;
    SourceTable = Incident;
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            field(Picture; Rec.Picture)
            {
                Caption = 'Picture';
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
                    DeleteIncidentPicture();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions();
    end;

    var
        DeleteExportEnabled: Boolean;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Picture.COUNT() <> 0;
    end;

    procedure ImportFromDevice()
    var
        OverridePictureQst: Label 'The existing picture will be replaced. Do you want to continue?', Locked = false, MaxLength = 250;
        DialogTitleLbl: Label 'Import', Locked = false, MaxLength = 250;
        FromFilterLbl: Label 'All Files (*.*)|*.*', Locked = false, MaxLength = 250;
        PicInStream: InStream;
        FromFileName: Text;
    begin
        if Picture.Count() > 0 then
            if not Confirm(OverridePictureQst) then
                exit;

        if UploadIntoStream(DialogTitleLbl, '', FromFilterLbl, FromFileName, PicInStream) then begin
            Clear(Picture);
            Picture.ImportStream(PicInStream, FromFileName);
            Modify(true);
        end;
    end;

    procedure ExportToDevice()
    var
        TenantMedia: Record "Tenant Media";
        ImageLbl: Label '_Image', Locked = true, MaxLength = 250;
        PicInStream: InStream;
        Index: Integer;
        FileName: Text;
    begin
        if Picture.Count() = 0 then
            exit;

        for Index := 1 to Picture.Count() do
            if TenantMedia.Get(Picture.Item(Index)) then begin
                TenantMedia.calcfields(Content);
                if TenantMedia.Content.HasValue() then begin
                    FileName := TableCaption() + ImageLbl + format(Index) + GetTenantMediaFileExtension(TenantMedia);
                    TenantMedia.Content.CreateInStream(PicInStream);
                    DownloadFromStream(PicInStream, '', '', '', FileName);
                end;
            end;
    end;

    procedure DeleteIncidentPicture()
    var
        DeletePictureQst: Label 'Are you sure you want to delete the picture?', Locked = false, MaxLength = 250;
    begin
        IF NOT CONFIRM(DeletePictureQst) THEN
            EXIT;

        CLEAR(Picture);
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
codeunit 50102 "Media Mgt."
{
    var
        tempblob: Codeunit "Temp Blob";
        Base64Convert: codeunit "Base64 Convert";

    local procedure GetItemPictureToBase64String(Item: Record Item): Text;
    var
        TenantMedia: Record "Tenant Media";
        PictureText: Text;
        PictureInStream: InStream;
        PictureOutStream: OutStream;
    begin
        if Item.Picture.Count() = 0 then
            exit('');

        TenantMedia.Get(Item.Picture.Item(1));
        TenantMedia.CalcFields(Content);
        if TenantMedia.Content.HasValue() then begin
            clear(PictureText);
            clear(PictureInStream);
            TenantMedia.Content.CreateInStream(PictureInStream);
            tempblob.CreateOutStream(PictureOutStream);
            CopyStream(PictureOutStream, PictureInStream);
            PictureText := Base64Convert.ToBase64(PictureInStream);
            exit(PictureText);
        end;

        exit('');
    end;

    local procedure SetItemPictureFromBase64String(var Item: Record Item; NewPictureText: Text)
    var
        PictureInStream: InStream;
    begin
        if NewPictureText = '' then
            exit;

        Base64Convert.FromBase64(NewPictureText);
        tempblob.CreateInStream(PictureInStream);

        clear(item.Picture);
        item.Picture.ImportStream(PictureInStream, item."No." + ' ' + item.Description + '.jpg');
        item.Modify(true);
    end;

    procedure ConvertInStreamToText(MyInStream: InStream): Text;
    var
        MyOutStream: OutStream;
        InStreamText: Text;
    begin
        tempblob.CreateOutStream(MyOutStream);
        CopyStream(MyOutStream, MyInStream);
        InStreamText := Base64Convert.ToBase64(MyInStream);
        exit(InStreamText);
    end;

    procedure ConvertTextToInStream(MyText: Text; var MyInStream: InStream; var FileExtension: Text)
    var
        MimeType: text;
    begin
        if CopyStr(MyText, 1, 4) = 'data' then begin
            MimeType := CopyStr(MyText, StrPos(MyText, ':') + 1, StrPos(MyText, ';') - 1);
            FileExtension := GetFileExtension(MimeType);
            MyText := CopyStr(MyText, StrPos(MyText, ',') + 1);
        end;
        Base64Convert.ToBase64(MyText);
        tempblob.CreateInStream(MyInStream);
    end;

    local procedure GetFileExtension(MimeType: Text): Text;
    begin
        case MimeType of
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
                exit('.' + CopyStr(MimeType, StrPos(MimeType, '/') + 1));
        end;
    end;
}
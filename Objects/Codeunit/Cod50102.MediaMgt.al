codeunit 50102 "Media Mgt."
{
    var
        TempBlob: record TempBlob temporary;

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
            TempBlob.Init();
            TempBlob.Blob.CreateOutStream(PictureOutStream);
            CopyStream(PictureOutStream, PictureInStream);
            TempBlob.Insert();
            TempBlob.CalcFields(Blob);
            PictureText := TempBlob.ToBase64String();
            TempBlob.Delete();
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

        TempBlob.FromBase64String(NewPictureText);
        TempBlob.Blob.CreateInStream(PictureInStream);

        clear(item.Picture);
        item.Picture.ImportStream(PictureInStream, item."No." + ' ' + item.Description + '.jpg');
        item.Modify(true);
    end;

    procedure ConvertInStreamToText(MyInStream: InStream): Text;
    var
        MyOutStream: OutStream;
        InStreamText: Text;
    begin
        TempBlob.Init();
        TempBlob.Blob.CreateOutStream(MyOutStream);
        CopyStream(MyOutStream, MyInStream);
        TempBlob.Insert();
        TempBlob.CalcFields(Blob);
        InStreamText := TempBlob.ToBase64String();
        TempBlob.Delete();
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
        TempBlob.FromBase64String(MyText);
        TempBlob.Blob.CreateInStream(MyInStream);
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
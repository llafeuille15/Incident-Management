pageextension 50102 "Cust. List Incident" extends "Customer List"
{
    actions
    {
        modify(Dimensions)
        {
            Visible = false;
        }

        AddLast("&Customer")
        {
            action(Export)
            {
                Caption = 'Export';
                ApplicationArea = All;
                Image = Export;
                Promoted = true;

                trigger OnAction();
                var
                    TempBlob: Codeunit "Temp Blob";
                    MyOutStream: OutStream;
                    MyInStream: InStream;
                    FileName: Text;
                begin
                    TempBlob.CreateOutStream(MyOutStream);
                    Xmlport.Export(Xmlport::"Export Customer", MyOutStream);
                    TempBlob.CreateInStream(MyInStream);
                    FileName := Rec.TableCaption() + '.txt';
                    DownloadFromStream(MyInStream, '', '', '', FileName);
                end;
            }
            action(Incident)
            {
                Caption = 'Incident';
                ApplicationArea = All;
                Image = Alerts;
                Promoted = true;
                RunObject = page "Incident List";
                RunPageLink = "Customer No." = field("No.");
            }
        }
    }
}
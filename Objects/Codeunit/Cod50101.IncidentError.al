codeunit 50101 "Incident - Error"
{
    TableNo = Incident;

    trigger OnRun()
    begin
        Rec.Comment := 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz';
        Rec.Modify(true);
    end;
}
codeunit 50100 "Incident Installer"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitIncident();
        InitWebService();
    end;

    local procedure InitIncident()
    var
        Incident: Record Incident;
        AccountingPeriod: record "Accounting Period";
        Customer: record Customer;
        Interval: record Date;
        StartDate: Date;
        EndDate: Date;
        nbInterval: Integer;
        i: Integer;
        EntryNo: Integer;
        j: Integer;
        AlphabetTxt: Label 'abcdefghijklm nopqrstuvwxyz', Locked = true, MaxLength = 250;

    begin
        Incident.DeleteAll(true);

        AccountingPeriod.SetRange(Closed, false);
        AccountingPeriod.SetRange("Fiscally Closed", false);
        if AccountingPeriod.IsEmpty() then
            exit;

        if Customer.IsEmpty() then
            exit;

        AccountingPeriod.FindFirst();
        StartDate := AccountingPeriod."Starting Date";
        AccountingPeriod.FindLast();
        EndDate := CalcDate('<-1D>', AccountingPeriod."Starting Date");

        Interval.SetRange("Period Type", Interval."Period Type"::"Date");
        Interval.SetRange("Period Start", StartDate, EndDate);
        nbInterval := Interval.Count();

        Customer.FindSet(false, false);
        repeat
            for i := 1 to Random(10) do begin
                Interval.FindSet(false, false);
                Interval.Next(Random(nbInterval));

                EntryNo += 1;

                Incident.Init();
                Incident.Validate("Entry No.", EntryNo);
                Incident.validate("Customer No.", Customer."No.");
                Incident.Validate("Date", Interval."Period Start");
                case random(2) of
                    1:
                        Incident.Validate(Type, Incident.Type::Support);
                    2:
                        Incident.Validate(Type, Incident.Type::Equipment);
                end;
                Incident.Validate("Duration (Hours)", random(7));
                for j := 1 to random(30) do
                    Incident.Comment += CopyStr(AlphabetTxt, random(27), 1);

                Incident.Insert(true);
            end;
        until Customer.Next() = 0;
    end;

    local procedure InitWebService()
    var
        TenantWebService: Record "Tenant Web Service";
        IncidentCardLbl: label 'Incident', Locked = true, MaxLength = 250;
        IncidentByYearLbl: label 'IncidentByYear', Locked = true, MaxLength = 250;
    begin
        if not TenantWebService.Get(TenantWebService."Object Type"::Page, IncidentCardLbl) then begin
            TenantWebService.Init();
            TenantWebService.validate("Object Type", TenantWebService."Object Type"::Page);
            TenantWebService.Validate("Service Name", IncidentCardLbl);
            TenantWebService.Insert(true);
        end;
        TenantWebService.Validate("Object ID", page::"Incident Card");
        TenantWebService.Validate(Published, true);
        TenantWebService.Modify(true);

        if not TenantWebService.Get(TenantWebService."Object Type"::Query, IncidentByYearLbl) then begin
            TenantWebService.Init();
            TenantWebService.validate("Object Type", TenantWebService."Object Type"::Query);
            TenantWebService.Validate("Service Name", IncidentByYearLbl);
            TenantWebService.Insert(true);
        end;
        TenantWebService.Validate("Object ID", Query::"Incident by Year");
        TenantWebService.Validate(Published, true);
        TenantWebService.Modify(true);
    end;
}
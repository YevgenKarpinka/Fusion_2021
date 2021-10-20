codeunit 50016 "User Entry Management"
{
    trigger OnRun()
    begin

    end;

    var
        UserSetup: Record "User Setup";

    local procedure GetUserSetup(): Boolean
    begin
        exit(UserSetup.Get(UserId));
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterLogInEnd', '', false, false)]
    local procedure HandleOnAfterLogInEnd()
    begin
        if GetUserSetup() and UserSetup."Enable Today as Work Date" then
            WorkDate(DT2Date(CurrentDateTime));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, 'OnAfterLogInStart', '', false, false)]
    local procedure HandleOnAfterLogInStart()
    begin
        if GetUserSetup() and UserSetup."Enable Today as Work Date" then
            WorkDate(DT2Date(CurrentDateTime));
    end;
}
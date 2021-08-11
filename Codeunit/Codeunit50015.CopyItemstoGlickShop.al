codeunit 50015 "Copy Items to GlickShop"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventItem(var Rec: Record Item)
    begin
        if Rec.IsTemporary then exit;
        if CheckItemFieldsFilled(Rec) then begin
            CopyItemMMS2GLS(Rec."No.");
            TransItemToSite.AddItemForTransferToSite(Rec."No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventItem(var Rec: Record Item)
    begin
        if Rec.IsTemporary then exit;
        if CheckItemFieldsFilled(Rec) then begin
            CopyItemMMS2GLS(Rec."No.");
            TransItemToSite.AddItemForTransferToSite(Rec."No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 50000, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventItemDescr(var Rec: Record "Item Description")
    var
        locItem: Record Item;
    begin
        if Rec.IsTemporary then exit;
        if not locItem.Get(Rec."Item No.") then exit;

        if CheckItemFieldsFilled(locItem) then
            TransItemToSite.AddItemForTransferToSite(locItem."No.");

    end;

    [EventSubscriber(ObjectType::Table, 50000, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEventItemDescr(var Rec: Record "Item Description")
    var
        locItem: Record Item;
    begin
        if Rec.IsTemporary then exit;
        if not locItem.Get(Rec."Item No.") then exit;

        if CheckItemFieldsFilled(locItem) then
            TransItemToSite.AddItemForTransferToSite(locItem."No.");

    end;

    procedure CheckItemFieldsFilled(Rec: Record Item): Boolean
    begin
        if Rec."No." = '' then exit(false);
        if Rec.Description = '' then exit(false);
        if Rec."Base Unit of Measure" = '' then exit(false);
        if Rec.IsInventoriableType() then
            if Rec."Inventory Posting Group" = '' then exit(false);
        // if Rec."VAT Prod. Posting Group" = '' then exit(false);
        if Rec."Gen. Prod. Posting Group" = '' then exit(false);
        if Rec."Sales Unit of Measure" = '' then exit(false);
        if Rec."Purch. Unit of Measure" = '' then exit(false);

        exit(true);
    end;

    local procedure CopyItemMMS2GLS(ItemNo: Code[20])
    var
        ICPartner: Record "IC Partner";
        ItemFrom: Record Item;
        ItemTo: Record Item;
        ItemUoMFrom: Record "Item Unit of Measure";
        ItemUoMTo: Record "Item Unit of Measure";
        UoMFrom: Record "Unit of Measure";
        UoMTo: Record "Unit of Measure";
        DaleteAllFlag: Boolean;
        blankGuid: Guid;
    begin
        GLSetup.Get();
        if not GLSetup."Transfer Items Allowed" then exit;

        // get item systemId from IC
        ICPartner.SetRange(Code, 'GLICKSHOP');
        ICPartner.FindFirst();
        // ItemTo.ChangeCompany(ICPartner."Inbox Details");

        ItemTo.ChangeCompany(ICPartner."Inbox Details");
        ItemUoMTo.ChangeCompany(ICPartner."Inbox Details");
        UoMTo.ChangeCompany(ICPartner."Inbox Details");

        ItemFrom.Get(ItemNo);
        if UoMFrom.FindSet() then
            repeat
                if UoMTo.Get(UoMFrom.Code) then begin
                    if UoMTo."Last Modified Date Time" <> UoMFrom."Last Modified Date Time" then begin
                        UoMTo.TransferFields(UoMFrom, false);
                        UoMTo.Modify()
                    end;
                end else begin
                    UoMTo.TransferFields(UoMFrom);
                    UoMTo.Insert();
                end;
            until UoMFrom.Next() = 0;

        if ItemTo.Get(ItemFrom."No.") then begin
            if ItemTo."Last DateTime Modified" <> ItemFrom."Last DateTime Modified" then begin
                ItemTo.TransferFields(ItemFrom, false);
                ItemTo.Modify();
            end;
        end else begin
            ItemTo.Init();
            ItemTo.TransferFields(ItemFrom);
            ItemTo.Insert();
        end;

        if (ItemFrom."Sales Unit of Measure" <> '')
        and not ItemUoMTo.Get(ItemFrom."No.", ItemFrom."Sales Unit of Measure") then begin

            ItemUoMFrom.SetRange("Item No.", ItemFrom."No.");
            if ItemUoMFrom.FindSet() then
                repeat
                    ItemUoMTo.TransferFields(ItemUoMFrom);
                    if ItemUoMTo.Insert() then ItemUoMTo.Modify();
                until ItemUoMFrom.Next() = 0;
        end;

    end;

    var
        GLSetup: Record "General Ledger Setup";
        ConfProgressBar: Codeunit "Config Progress Bar";
        TransItemToSite: Codeunit "Transfer Items To Site Mgt";
        txtCopyItemToCompany: TextConst ENU = 'From Company %1 To Company %2',
                                        RUS = 'С Организации %1 в Организацию %2';
        txtProcessHeader: TextConst ENU = 'Copy Item %1',
                                    RUS = 'Копирование товара %1';
        blankGuid: Guid;
        Base64Convert: Codeunit "Base64 Convert";
        qstSendItemsToCRM: TextConst ENU = 'Send Items To CRM?', RUS = 'Отправлять товары в CRM?';
        ApplyingURLMsg: TextConst ENU = 'Sending Table %1',
                                RUS = 'Пересылается таблица %1';
        RecordsXofYMsg: TextConst ENU = 'Records: %1 of %2',
                                RUS = 'Запись: %1 из %2';
        sentToCRM: Boolean;
        ConfigProgressBarRecord: Codeunit "Config Progress Bar";
        globalItemId: Guid;
}
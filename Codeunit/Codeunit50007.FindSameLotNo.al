codeunit 50007 "Find Same Lot No"
{
    Permissions = tabledata "Posted Whse. Receipt Line" = r, tabledata "Put-away Template Line" = r,
    tabledata "Bin Content" = rm, tabledata "Warehouse Activity Line" = r, tabledata "Warehouse Activity Header" = rm;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnFindBinContent', '', true, true)]
    local procedure CreatePutawayOnFindBinContent(PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; PutAwayTemplateLine: Record "Put-away Template Line"; var BinContent: Record "Bin Content")
    begin
        if PutAwayTemplateLine."Find Same Lot No." then
            BinContent.SetRange("Lot No.", PostedWhseReceiptLine."Lot No.")
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnFindBin', '', true, true)]
    local procedure CreatePutawayOnFindBin(PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; PutAwayTemplateLine: Record "Put-away Template Line"; var Bin: Record Bin)
    begin
        if PutAwayTemplateLine."Find Same Lot No." then
            Bin.SetRange("Lot No.", PostedWhseReceiptLine."Lot No.")
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnBeforeCreateNewWhseActivity', '', true, true)]
    local procedure LotNo2BinContent(PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    var
        BinContent: Record "Bin Content";
    begin
        if BinContent.Get(PostedWhseRcptLine."Location Code", PostedWhseRcptLine."Bin Code", PostedWhseRcptLine."Item No.",
                PostedWhseRcptLine."Variant Code", PostedWhseRcptLine."Unit of Measure Code") then begin
            BinContent."Lot No." := PostedWhseRcptLine."Lot No.";
            BinContent.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnAfterSplitPostedWhseReceiptLine', '', true, true)]
    local procedure UpdateSourceDocumentIntoHeader(var TempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary)
    var
        locTempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary;
        locLocation: Record Location;
        LineNo: Integer;
    begin
        if locLocation.Get(TempPostedWhseRcptLine."Location Code")
        and locLocation."Sorting by Expired Date" then begin
            TempPostedWhseRcptLine.SetCurrentKey("Location Code", "Item No.", "Lot No.", "Expiration Date");
            if TempPostedWhseRcptLine.FindSet() then
                repeat
                    LineNo += 10000;
                    locTempPostedWhseRcptLine := TempPostedWhseRcptLine;
                    if locTempPostedWhseRcptLine."Line No." <> LineNo then
                        locTempPostedWhseRcptLine."Line No." := LineNo;
                    locTempPostedWhseRcptLine.Insert();
                until TempPostedWhseRcptLine.Next() = 0;

            TempPostedWhseRcptLine.DeleteAll();
            if locTempPostedWhseRcptLine.FindSet() then
                repeat
                    TempPostedWhseRcptLine := locTempPostedWhseRcptLine;
                    TempPostedWhseRcptLine.Insert();
                until locTempPostedWhseRcptLine.Next() = 0;
        end;
    end;
}
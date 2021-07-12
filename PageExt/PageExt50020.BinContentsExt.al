pageextension 50020 "Bin Contents Ext." extends "Bin Contents"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
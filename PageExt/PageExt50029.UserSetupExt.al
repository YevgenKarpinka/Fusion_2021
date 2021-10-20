pageextension 50029 "User Setup Ext" extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("User ID")
        {
            field("Enable Today as Work Date"; Rec."Enable Today as Work Date")
            {
                ApplicationArea = All;
            }
        }
    }
}
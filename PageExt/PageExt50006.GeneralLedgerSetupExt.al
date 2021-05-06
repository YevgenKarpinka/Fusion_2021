pageextension 50006 "General Ledger Setup Ext." extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Application)
        {
            group(BankChecks)
            {
                CaptionML = ENU = 'Bank Checks', RUS = 'Банковские Чеки';

                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                    // Importance = Additional;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                    // Importance = Additional;
                }
            }
        }
        addafter(Application)
        {
            group(eCommerce)
            {
                field("Transfer Items Allowed"; Rec."Transfer Items Allowed")
                {
                    ApplicationArea = All;
                    // Importance = Additional;
                }
                field("Transfer Items Job Queue Only"; Rec."Transfer Items Job Queue Only")
                {
                    ApplicationArea = All;
                    // Importance = Additional;
                }
                field("Save Error To File"; Rec."Save Error To File")
                {
                    ApplicationArea = All;
                    // Importance = Additional;
                }
            }
        }
    }
}
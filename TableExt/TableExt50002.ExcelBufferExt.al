tableextension 50002 "Excel Buffer Ext." extends "Excel Buffer"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Cell Value Blob"; Blob)
        {
            CaptionML = ENU = 'Cell Value BLOB', RUS = 'Значение ячейки в BLOB формате';
            DataClassification = CustomerContent;
            Subtype = Memo;
        }
    }
}

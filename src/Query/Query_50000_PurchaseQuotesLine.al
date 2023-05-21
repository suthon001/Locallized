query 50001 "GroupPurchaseQuotes"
{
    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            column(Document_Type; "Document Type") { }
            column(Status; Status) { }
            column(Select_By; "Select By") { }
            column(Select_Vendor_No_; "Select Vendor No.")
            {
            }

        }
    }
}
Sub ClearFields()
    'Reset fields and Accept button
    With Me
            .tbTicketNo = ""
            .cmbOpenBy = ""
            .tbCustID = ""
            .tbCustName = ""
            .tbCustPhone = ""
            .tbIssue = ""
            .tbMachSN = ""
            .tbDateOpen = ""
            .tbDateClose = ""
            .tbComments = ""
            .btnAccept.Enabled = False
            .btnAccept.Caption = "Accept"
            .tbTicketNo.Locked = False
            .cbFixed.Value = False
        End With
End Sub

Private Sub btnAccept_Click()
    'If Ticket Number Empty...
    If Me.tbTicketNo.Value = "" Then
        Unload Me
        Exit Sub
    End If
    
    'Set sheet name
    Dim issSheet As Worksheet
    Set issSheet = ThisWorkbook.Sheets("Issue Log")
    
    'Write Values
    issSheet.Cells(Me.tbTicketNo.Value + 5, 2) = Me.tbTicketNo.Value
    issSheet.Cells(Me.tbTicketNo.Value + 5, 3) = Me.cmbOpenBy.Value
    issSheet.Cells(Me.tbTicketNo.Value + 5, 4) = Me.tbCustID.Value
    issSheet.Cells(Me.tbTicketNo.Value + 5, 5) = Me.tbCustName.Value
    issSheet.Cells(Me.tbTicketNo.Value + 5, 6) = Me.tbCustPhone.Value
    issSheet.Cells(Me.tbTicketNo.Value + 5, 7) = Me.tbIssue.Value
    issSheet.Cells(Me.tbTicketNo.Value + 5, 8) = Me.tbMachSN.Value
    issSheet.Cells(Me.tbTicketNo.Value + 5, 9) = CDate(Me.tbDateOpen.Value)
    
    'But if no Close Date...
    If Me.tbDateClose.Value <> "" Then
        issSheet.Cells(Me.tbTicketNo.Value + 5, 10) = CDate(Me.tbDateClose.Value)
    End If
    
    issSheet.Cells(Me.tbTicketNo.Value + 5, 11) = Me.tbComments.Value & vbNewLine & "Updated on " & Format(Now)
    Unload Me
End Sub

Private Sub btnClear_Click()
    With Me
        .tbTicketNo = ""
        ClearFields
    End With
End Sub

Private Sub btnCustID_Click()

    'Save Customer's ID
    Dim custID
    custID = Me.tbCustID.Value
    
    'Clean Everything!
    ClearFields
    
    'Restore Customer's ID
    Me.tbCustID.Value = custID
    
    'If nothing was input
    If Me.tbCustID.Value = "" Then
        MsgBox ("Input Customer's ID in Customer's ID field")
        Exit Sub
    End If
    
    'Check if value non existing
    If WorksheetFunction.CountIf(Sheet1.Range("D:D"), Me.tbCustID.Value) = 0 Then
        MsgBox ("Customer's ID not found")
        Exit Sub
    End If
    
    'If existing, find the ticket number and then just do a ticket number search.
    With Me
        .tbTicketNo = Evaluate("LOOKUP(2,1/(D:D =" & Me.tbCustID.Value & "),B:B)")
        btnSearchByTicketNo_Click
    End With
End Sub

Private Sub btnCustPhone_Click()
    'Save Customer's Phone
    Dim custPhone
    custPhone = Me.tbCustPhone
    
    'Clean Everything!
    ClearFields
    
    'Restore Customer's Phone
    Me.tbCustPhone = custPhone
    
    'If nothing was input
    If Me.tbCustPhone.Value = "" Then
        MsgBox ("Input Customer's Phone in Customer's Phone field")
        Exit Sub
    End If
    
    'If value non existing
    If WorksheetFunction.CountIf(Sheet1.Range("F:F"), Me.tbCustPhone.Value) = 0 Then
        MsgBox ("Customer's Phone not found")
        Exit Sub
    End If
      
    'If existing, find the ticket number and then just do a ticket number search.
    With Me
        .tbTicketNo = Evaluate("LOOKUP(2,1/(F:F =""" & Me.tbCustPhone.Value & """),B:B)")
        btnSearchByTicketNo_Click
    End With
End Sub

Private Sub btnMarkAsFixed_Click()
    Me.tbDateClose = Date
    Me.cbFixed.Value = True
End Sub

Private Sub btnSearchByTicketNo_Click()
    'Save Ticket Number
    Dim ticketNo
    ticketNo = Me.tbTicketNo.Value
    
    'CleanEverything!
    ClearFields
    
    'Restore Ticket Number
    Me.tbTicketNo.Value = ticketNo
    
    'If nothing was input
    If Me.tbTicketNo.Value = "" Then
        MsgBox ("Input Ticket Number in Ticket Number field")
        Exit Sub
    End If
    
    'Check if value non existing
    If WorksheetFunction.CountIf(Sheet1.Range("B:B"), Me.tbTicketNo.Value) = 0 Then
        MsgBox ("Ticket Number not found")
        Exit Sub
    End If
    
    
    'If existing, lookup for existing values then
    With Me
        .cmbOpenBy = Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 2, 0)
        .tbCustID = Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 3, 0)
        .tbCustName = Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 4, 0)
        .tbCustPhone = Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 5, 0)
        .tbIssue = Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 6, 0)
        .tbMachSN = Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 7, 0)
        .tbDateOpen = CDate(Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 8, 0))
        If Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 9, 0) <> "" Then
            .tbDateClose = CDate(Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 9, 0))
            .cbFixed.Value = True
        End If
        .tbComments = Application.WorksheetFunction.VLookup(CLng(Me.tbTicketNo), Sheet1.Range("issueTable"), 10, 0)
        
        'Also enable the button
        .btnAccept.Caption = "Update Ticket"
        .btnAccept.Enabled = True
        
        'And disable ticket field
        .tbTicketNo.Locked = True
    End With
End Sub

Private Sub btwNewTicket_Click()
    ClearFields
    LastRow = ThisWorkbook.Sheets("Issue Log").Cells(Rows.Count, 2).End(xlUp).End(xlUp).Row - 4
    Me.tbTicketNo.Value = LastRow
    Me.tbTicketNo.Locked = True
    Me.tbDateOpen = Date
    Me.btnAccept.Caption = "Create"
    Me.btnAccept.Enabled = True
End Sub

Private Sub tbTicketNo_AfterUpdate()
    btnSearchByTicketNo_Click
End Sub
Private Sub tbCustID_AfterUpdate()
    If Me.tbTicketNo.Value <> "" Or Me.tbCustID.Value = "" Then
          Exit Sub
    End If
    btnCustID_Click
End Sub
Private Sub tbCustPhone_AfterUpdate()
    Me.tbCustPhone.Value = Format(Me.tbCustPhone.Value, "(###) ### - ####")
    If Me.tbTicketNo.Value <> "" Or Me.tbCustPhone.Value = "" Then
          Exit Sub
    End If
    btnCustPhone_Click
End Sub

Private Sub UserForm_Initialize()
        'Fill ComboBox!
        For Each wkName In [OpenByList]
            Me.cmbOpenBy.AddItem wkName
        Next wkName
End Sub

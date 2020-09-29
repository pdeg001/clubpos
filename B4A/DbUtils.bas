B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Private sql As SQL
	Private curs As Cursor
	Private qry As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
	DbInitalized
End Sub

Private Sub DbInitalized
	If sql.IsInitialized = False Then
		sql.Initialize(Main.filePath, "clubpos.db", False)
	End If
End Sub


#Region BTW
Public Sub AddBtw(lst As List) As List
	DbInitalized
	Dim lstData As List
	Dim id As String = UUIDv4
	
	lstData.Initialize
	qry = "INSERT INTO btw_tarief (id, omschrijving, tarief) VALUES (?,?,?)"
	sql.ExecNonQuery2(qry, Array As String(id, lst.Get(0), lst.Get(1)))
	
	lstData.Add(Array As String(id, lst.Get(0), lst.Get(1)))
	Return lstData
End Sub

Public Sub GetBtw As List
	DbInitalized
	Dim lst As List
	
	qry = "SELECT * FROM btw_tarief ORDER BY tarief"
	curs = sql.ExecQuery(qry)
	
	lst.Initialize
	
	For i = 0 To curs.RowCount -1
		curs.Position = i
		lst.Add(Array As String(curs.GetString("id"), curs.GetString("omschrijving"), curs.GetString("tarief")))
	Next
	
	curs.Close
	Return lst
End Sub

Public Sub DeleteBtw(id As String)
	DbInitalized
	qry = "DELETE FROM btw_tarief WHERE id = ?"
	sql.ExecNonQuery2(qry, Array As String(id))
End Sub

Public Sub UpdateBtw(id As String, descr As String, rate As String)
	DbInitalized
	qry = "UPDATE btw_tarief SET omschrijving=?, tarief=? WHERE id=?"
	sql.ExecNonQuery2(qry, Array As String(descr, rate, id))
End Sub

#End Region

Sub UUIDv4 As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each stp As Int In Array(8, 4, 4, 4, 12)
		If sb.Length > 0 Then sb.Append("-")
		For n = 1 To stp
			Dim c As Int = Rnd(0, 16)
			If c < 10 Then c = c + 48 Else c = c + 55
			If sb.Length = 19 Then c = Asc("8")
			If sb.Length = 14 Then c = Asc("4")
			sb.Append(Chr(c))
		Next
	Next
	Return sb.ToString.ToLowerCase
End Sub


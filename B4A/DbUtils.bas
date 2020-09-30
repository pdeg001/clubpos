B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Private sql As SQL
	Private rs As ResultSet
	Private curs As Cursor
	Private qry As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	DbInitalized
	CheckArticleTableExists
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
	Starter.lstBtw.Initialize
	
	For i = 0 To curs.RowCount -1
		curs.Position = i
		lst.Add(Array As String(curs.GetString("id"), curs.GetString("omschrijving"), curs.GetString("tarief")))
		Starter.lstBtw.Add(CreatebtwCursor(curs.GetString("id"), curs.GetString("omschrijving"), curs.GetString("tarief")))
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

Public Sub GetAllBtwForAddProduct
	Dim btw As String
	
	DbInitalized
	
	qry = "SELECT omschrijving, tarief FROM btw_tarief ORDER BY tarief"
	curs = sql.ExecQuery(qry)
	
	Starter.btwRate.Initialize
	
	For i = 0 To curs.RowCount -1
		curs.Position = i
		If i < curs.RowCount Then
			btw = btw &curs.GetString("tarief")&CRLF
		Else
			btw = btw &curs.GetString("tarief")
		End If
		
	Next
	File.WriteString(Main.filePath, "btw.txt", btw)
	curs.Close
	Sleep(100)
End Sub

Public Sub GetBtwId(btw As String) As String
	Dim id As String
	DbInitalized
	qry = "SELECT id FROM btw_tarief WHERE omschrijving=?"
	curs = sql.ExecQuery2(qry, Array As String(btw))
	If curs.RowCount = 0 Then
		id = ""
	Else
		curs.Position = 0
		id = curs.GetString("id")
	End If
	curs.Close
	Return id
End Sub

Public Sub GetBtwPerc(id As String) As Float
	Dim rate As Float
	DbInitalized
	qry = "SELECT tarief FROM btw_tarief WHERE id=?"
	curs = sql.ExecQuery2(qry, Array As String(id))
	If curs.RowCount = 0 Then
		rate = 0
	Else
		curs.Position = 0
		rate = curs.GetString("tarief")	
	End If
	curs.Close
	Return rate
End Sub

Public Sub CheckIfRateExists(rate As String) As Boolean
	DbInitalized
	qry = "SELECT COUNT(*) FROM btw_tarief WHERE tarief=?"
	curs = sql.ExecQuery2(qry, Array As String(rate))
	
	Return curs.RowCount > 0
End Sub

Public Sub CreatebtwCursor (id As String, description As String, rate As String) As btwCursor
	Dim t1 As btwCursor
	t1.Initialize
	t1.id = id
	t1.description = description
	t1.rate = rate
	Return t1
End Sub
#End Region

#Region PRODUCT
Public Sub AddProduct(descr As String, price As String, btw As String) As List
	DbInitalized
	Dim id As String = UUIDv4
	Dim lst As List
	
	qry = "INSERT INTO artikel (id, omschrijving, prijs_ex_btw, btw_perc) VALUES(?,?,?,?)"
	sql.ExecNonQuery2(qry, Array As String(id, descr, price, btw))
	
	lst.Initialize
	lst.Add(CreateprodCursor(id, descr, price, btw))
	
	Return lst
End Sub

Public Sub UpdateProduct(id As String, descr As String, price As String, btw As String) As List
	DbInitalized
	Dim lst As List
	qry = "UPDATE artikel SET omschrijving=?, prijs_ex_btw=?, btw_perc=? WHERE id=?"
	sql.ExecNonQuery2(qry, Array As String(descr, price, btw, id))
	
'	qry = $"Select a.id as id
'			,a.omschrijving as omschrijving
'			,b.tarief as btw_perc
'			,a.prijs_ex_btw as prijs_ex_btw 
'			FROM artikel a
'			INNER join btw_tarief b on
'			b.id = a.btw_perc
'			WHERE a.id=?"$
'	curs = sql.ExecQuery2(qry, Array As String(id))
'	
'	curs.Position = 0		
	lst.Initialize
	'lst.Add(CreateprodCursor(curs.GetString("id"), curs.GetString("omschrijving"), curs.GetString("prijs_ex_btw"), curs.GetString("btw_perc")))
	lst.Add(CreateprodCursor(id, descr, price, btw))
	curs.Close
	Return lst
End Sub

Public Sub GetBtwById(id As String) As String
	Dim id As String
	DbInitalized
	qry = "SELECT tarief FROM btw_tarief WHERE id=?"
	curs = sql.ExecQuery2(qry, Array As String(id))
	id = curs.GetString("id")
	Return id
End Sub

Public Sub DeleteProduct(id As String)
	DbInitalized
	qry = "DELETE FROM artikel WHERE id=?"
	sql.ExecNonQuery2(qry, Array As String(id))
End Sub

Public Sub GetAllProducts As List
	DbInitalized
	Dim lstObj As List
	qry = $"Select a.id as id
			,a.omschrijving as omschrijving
			,b.tarief as btw_perc
			,a.prijs_ex_btw as prijs_ex_btw 
			FROM artikel a
			INNER join btw_tarief b on
			b.id = a.btw_perc"$
	curs = sql.ExecQuery(qry)
	
	lstObj.Initialize
	For i = 0 To curs.RowCount -1
		curs.Position = i
		lstObj.Add(CreateprodCursor(curs.GetString("id"), curs.GetString("omschrijving"), curs.GetString("prijs_ex_btw"), curs.GetString("btw_perc")))
	Next
	curs.Close
	Return lstObj
End Sub




Public Sub CreateprodCursor (id As String, description As String, price As String, btw As String) As prodCursor
	Dim t1 As prodCursor
	t1.Initialize
	t1.id = id
	t1.description = description
	t1.price = price
	t1.btw = btw
	Return t1
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

#Region CreateUpdateTable
Public Sub CheckArticleTableExists
	DbInitalized
	qry = $"CREATE TABLE IF NOT EXISTS artikel
		(
			"id"	TEXT UNIQUE,
			"omschrijving"	TEXT,
			"btw_perc"	NUMERIC,
			"prijs_ex_btw"	NUMERIC,
			"btw_id"	TEXT,
			PRIMARY KEY("id")
		)"$
	
	sql.ExecNonQuery(qry)
End Sub
#End Region

B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
#IgnoreWarnings:12
Sub Class_Globals
	Private psx As String = "clubpos"
	Private su As StringUtils
	Private pwx As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
End Sub

Public Sub CheckPassword(pw As String)
		B4XPages.ShowPage("appMenu")
	'---TEMP DISABLED	
'	pwx = pw
'	If File.Exists(Main.filePath, "psx.cp") = False Then
'		File.WriteString(Main.filePath, "psx.cp", EncryptString(psx))
'	End If
'	
'	If DecryptString(File.ReadString(Main.filePath, "psx.cp")) <> "err" Then
'		Log("OK")
'	Else
'		Log("NOT OK")	
'	End If
	
End Sub

Sub EncryptString(Str As String) As String
	Dim c As B4XCipher
	Return su.EncodeBase64(c.Encrypt(Str.GetBytes("UTF8"), pwx))
End Sub

Sub DecryptString(str As String) As String
	Dim c As B4XCipher
	Dim baseStr() As Byte = su.DecodeBase64(str)
	
	Try
		Dim b() As Byte = c.Decrypt(baseStr, pwx)
	Catch
		Return "err"
	End Try
	
	Return EncryptToString(b)
End Sub

Private Sub EncryptToString(b() As Byte) As String
	Return BytesToString(b, 0, b.Length, "UTF8")
End Sub
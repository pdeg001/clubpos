B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

Sub Class_Globals
	Private Root As B4XView
	
	Private xui As XUI
	Private password As B4XFloatTextField
	Private btnContinue As B4XView
	Private clsPw As ClassPassWord
	
	Dim appMenu As appSetting
	Type btwCursor(id As String, description As String, rate As String)
	Type prodCursor(id As String, description As String, price As String, btw As String)
End Sub

Public Sub Initialize
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	clsPw.Initialize
	
	Root = Root1
	Root.LoadLayout("MainPage")
	appMenu.Initialize
	B4XPages.AddPage("appMenu", appMenu)
	password.RequestFocusAndShowKeyboard
	B4XPages.ShowPage("appMenu")
End Sub

Sub Activity_Resume
'	Log("PPP")
End Sub


'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Sub btnContinue_Click
	clsPw.CheckPassword(password.Text)
End Sub

Sub password_TextChanged (Old As String, New As String)
	If CheckPasswordLength(New) = False Then
		Return
	End If
End Sub

Sub CheckPasswordLength(pw As String) As Boolean
	Dim enable As Boolean = pw.Length >= 4
	
	btnContinue.Enabled = enable
	Return enable
End Sub


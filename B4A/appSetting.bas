B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private btnBtw As B4XView
	Private btnArtikel As B4XView
	
	Private btw As BtwInvoer
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("appSettings")
	
	btw.Initialize
	B4XPages.AddPage("btw", btw)
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Sub btnBtw_Click
	B4XPages.ShowPage("btw")
End Sub

Sub btnArtikel_Click
	
End Sub
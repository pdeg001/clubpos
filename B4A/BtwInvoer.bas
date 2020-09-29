B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private prefdialog As PreferencesDialog 'ignore
	Private ime As IME
	Private options As Map
	Private clsDb As DbUtils
	Private clsFunc As ClassFunction
	Private editRate As Boolean
	Private rateId As String
	Private selectedPanelIndex As Int
	
	
	Private clvBtwTarief As CustomListView
	Private btnAdd As B4XView
	Private pnlBtw As Panel
	Private lblDescriptionData As B4XView
	Private lblRateData As B4XView
	
	Private Button1 As B4XView
	Private lblEdit As B4XView
	Private lblDelete As Label
	Private txtDescription As B4XFloatTextField
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("btwTarief")
	prefdialog.Initialize(Root, "BTW Tarieven", 300dip, 300dip)
	clsDb.Initialize
	clsFunc.Initialize
	ime.Initialize("ime")
	ime.AddHeightChangedEvent
	GetRates
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Sub btnAdd_Click
	InitPrefDialog
	options.Initialize
	Dim sf As Object = prefdialog.ShowDialog(options, "OKE", "ANNULEER")
	clsFunc.PrefDialogCustom(prefdialog)
	
	'Wait For (prefdialog.ShowDialog(Options, "OKE", "ANNULEER")) Complete (Result As Int)
	Wait For (sf) Complete (Result As Int)
	
	If Result = xui.DialogResponse_Positive Then
		ProcessBtw(options)
	End If
End Sub

Sub ProcessBtw (OptionsPassed As Map)
	Dim lst, lstData As List
	Dim sb As StringBuilder
	Dim btwRow() As String
	
	sb.Initialize
	lst.Initialize
	lstData.Initialize
	
	For Each key As String In OptionsPassed.Keys
		If key = "btw_omschrijving" Then
			lst.Add(options.Get(key))
		End If
		If key = "btw_tarief" Then
			lst.Add(options.Get(key))
		End If
	Next
	
	If editRate Then
		ProcessEditRate(lst)
		editRate = False
	Else
		lstData = clsDb.AddBtw(lst)
		btwRow = lstData.Get(0)
		clvBtwTarief.Add(GenBtwList(btwRow), "")
	End If
End Sub

Sub ProcessEditRate(lst As List)
	clsDb.UpdateBtw(rateId, lst.Get(0), lst.Get(1))
	GetRates	
	clvBtwTarief.ScrollToItem(selectedPanelIndex)
End Sub

Sub GetRates
	Dim lst As List = clsDb.GetBtw
	Dim btwRow() As String
	clvBtwTarief.Clear

	For i = 0 To lst.Size -1
		btwRow = lst.Get(i)	
		clvBtwTarief.Add(GenBtwList(btwRow), "i")
	Next
	
End Sub

Sub GenBtwList(lst As List) As Panel
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, clvBtwTarief.AsView.Width, 230dip) '190
	p.LoadLayout("clvBtw")
	p.Tag = lst.Get(0)
	lblDescriptionData.Text = lst.Get(1)
	lblRateData.Text = $"${lst.Get(2)}%"$
'	lblDelete.Tag = lst.Get(0)

	Return p
End Sub

Sub IME_HeightChanged (NewHeight As Int, OldHeight As Int)
	prefdialog.KeyboardHeightChanged(NewHeight)
End Sub

Sub Button1_Click
	GetRates
End Sub

Sub lblDelete_Click
	Dim lbl As B4XView = Sender
	Dim pnl As B4XView = clsFunc.GetPanelFromViewClick(clvBtwTarief, lbl.Parent)
	Dim pnlIndex As Int = clsFunc.GetPanelIndex(clvBtwTarief, lbl.Parent)
	
	Msgbox2Async("Tarief verwijderen?","ClubPos", "JA", "", "NEE", Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.NEGATIVE Then
		Return
	End If
	
	clsDb.DeleteBtw(pnl.Tag)
	clvBtwTarief.RemoveAt(pnlIndex)
	
End Sub

Sub lblEdit_Click
	editRate = True
	Dim descr, rate As String
	Dim lbl As B4XView = Sender
	Dim pnl As B4XView = clsFunc.GetPanelFromViewClick(clvBtwTarief, lbl.Parent)
	selectedPanelIndex = clsFunc.GetPanelIndex(clvBtwTarief, lbl.Parent)
	
	rateId = pnl.Tag
	descr = clsFunc.GetValueFromLabelByTag(pnl,"description")
	rate = clsFunc.GetValueFromLabelByTag(pnl,"rate").Replace("%","")
	
	If descr = "err" Or rate = "err" Then
		Msgbox2Async($"Er gaat iets niet goed${CRLF}${CRLF}Fout code: 'TAG NOT FOUND'"$, "ClubPos", "OKE", "", "", Null, False)
		Wait For Msgbox_Result (Result As Int)
		If Result = DialogResponse.POSITIVE Then
			Return
		End If
	End If
	
	options.Initialize
	options = CreateMap("btw_omschrijving":descr,"btw_tarief":rate)
	
	InitPrefDialog
	
	Dim sf As Object = prefdialog.ShowDialog(options, "OKE", "ANNULEER")
	clsFunc.PrefDialogCustom(prefdialog)

	Wait For (sf) Complete (Result As Int)
	
	If Result = xui.DialogResponse_Positive Then
		ProcessBtw(options)
	End If
End Sub

Sub InitPrefDialog
	Dim dip As Int
	If clsFunc.GetDevicePhysicalSize > 6 Then
		dip = 400dip
	Else
		dip = 300dip
	End If
	'prefdialog.Initialize(Root, "BTW Tarieven", 300dip, 300dip)
	prefdialog.Initialize(Root, "BTW Tarieven", dip, 300dip)
	prefdialog.LoadFromJson(File.ReadString(File.DirAssets, "btw.json"))
End Sub
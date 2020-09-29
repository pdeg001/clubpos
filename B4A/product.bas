B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private clsFunc As ClassFunction
	Private clsDb As DbUtils
	
	Private prefdialog As PreferencesDialog 'ignore
	Private ime As IME
	Private options, optionBtw As Map
	
	
	Private pnlProduct As Panel
	Private lblEdit As Label
	Private lblDelete As Label
	Private lblDescriptionData As Label
	Private lblRateData As Label
	Private lblBtw As Label
	Private btnAdd As Button
	Private clvProduct As CustomListView
	Private lblPriceData As Label
	Private lblVerkoopPrijs As Label
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	clsFunc.Initialize
	clsDb.Initialize
	Root = Root1
	Root.LoadLayout("product")
	GetProducts
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Sub GetProducts
	Dim lst As List = clsDb.GetAllProducts
	clvProduct.Clear
	
	For i = 0 To lst.Size -1
		clvProduct.Add(GenListItem(lst.Get(i)), "")
	Next
	
End Sub

Sub btnAdd_Click
	clsDb.GetAllBtwForAddProduct
	InitPrefDialog
	prefdialog.SetOptions("btw", File.ReadList(Main.filePath, "btw.txt"))
	
	Dim sf As Object = prefdialog.ShowDialog(options, "OKE", "ANNULEER")
	clsFunc.PrefDialogCustom(prefdialog)

	Wait For (sf) Complete (Result As Int)
	
	If Result = xui.DialogResponse_Positive Then
		ProcessProduct(options)
	End If
End Sub


Sub ProcessProduct (OptionsPassed As Map)
	Dim lst, prodObj As List
	
	lst.Initialize
	
	For Each key As String In OptionsPassed.Keys
		If key = "oms" Then
			lst.Add(options.Get(key))
		End If
		If key = "price" Then
			lst.Add(options.Get(key))
		End If
		If key = "btw" Then
			lst.Add(options.Get(key))
		End If
	Next
	prodObj = clsDb.AddProduct(lst.Get(0), lst.Get(1), lst.Get(2))
	clvProduct.Add(GenListItem(prodObj.Get(0)), "")
End Sub




Sub GenListItem(prodObj As Object) As Panel
	Dim data As prodCursor = prodObj
	Dim p As B4XView = xui.CreatePanel("")
	Dim price As Float
	
	price = data.price+(data.price*data.btw)/100
	p.SetLayoutAnimated(0, 0, 0, clvProduct.AsView.Width, 230dip) '190
	p.LoadLayout("clvProduct")
	p.Tag = data.id
	lblDescriptionData.Text = data.description
	lblPriceData.Text = NumberFormat2(data.price,1,2,2,False)
	lblBtw.Text = $"${data.btw}%"$
	lblVerkoopPrijs.Text = NumberFormat2(price,1,2,2,False)
	Return p
End Sub


Sub IME_HeightChanged (NewHeight As Int, OldHeight As Int)
	prefdialog.KeyboardHeightChanged(NewHeight)
End Sub

Sub InitPrefDialog
	Dim dip As Int
	If clsFunc.GetDevicePhysicalSize > 6 Then
		dip = 400dip
	Else
		dip = 300dip
	End If
	
	options.Initialize
	prefdialog.Initialize(Root, "BTW Tarieven", dip, 300dip)
	prefdialog.LoadFromJson(File.ReadString(File.DirAssets, "artikel.json"))
End Sub

Sub lblDelete_Click
	Dim lbl As B4XView = Sender
	Dim pnl As B4XView = clsFunc.GetPanelFromViewClick(clvProduct, lbl.Parent)
	Dim pnlIndex As Int = clsFunc.GetPanelIndex(clvProduct, lbl.Parent)
	
	Msgbox2Async("Tarief verwijderen?","ClubPos", "JA", "", "NEE", Null, False)
	Wait For Msgbox_Result (Result As Int)
	If Result = DialogResponse.NEGATIVE Then
		Return
	End If
	
	clsDb.DeleteProduct(pnl.Tag)
	clvProduct.RemoveAt(pnlIndex)
End Sub
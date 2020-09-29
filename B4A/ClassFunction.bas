B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.2
@EndOfDesignText@
Sub Class_Globals
	Private xui As XUI
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

'Returns panel of clicked view
Public Sub GetPanelFromViewClick(clv As CustomListView, pnl As Panel) As Panel
	Return clv.GetPanel(clv.GetItemFromView(pnl))
End Sub

'Returns index of selected panel
Public Sub GetPanelIndex(clv As CustomListView, pnl As Panel) As Int
	Return clv.GetItemFromView(pnl)
End Sub

'Return the text value from label
Public Sub GetValueFromLabelByTag(p As Panel, tag As String) As String
	Dim lbl As B4XView
	For Each v As View In p.GetAllViewsRecursive
		If v.Tag = tag Then
			lbl = v
			Return lbl.Text
		End If
	Next
	Return "err"
End Sub

'Custom PreferencesDialog
Public Sub PrefDialogCustom(p As PreferencesDialog)
	For i = 0 To p.PrefItems.Size - 1
		'Dim pi As B4XPrefItem = p.PrefItems.Get(i)
		Dim ft As B4XFloatTextField = p.CustomListView1.GetPanel(i).GetView(0).Tag
		If ft = Null Then Continue

		ft.AnimationDuration = 0
		ft.TextField.Font = xui.CreateDefaultFont(20)
		ft.SmallLabelTextSize = 20
		ft.NonFocusedHintColor = Colors.Blue
		ft.TextField.Height = 70dip
		ft.Update
	Next
End Sub

'Is device a tablet
Public Sub GetDevicePhysicalSize As Float
	Dim lv As LayoutValues
	lv = GetDeviceLayoutValues
	Return Sqrt(Power(lv.Height / lv.Scale / 160, 2) + Power(lv.Width / lv.Scale / 160, 2))
End Sub


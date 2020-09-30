B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=9.85
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	#ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	Public btwRate As btwCursor
	Public lstBtw As List
End Sub

Sub Service_Create
	'This is the program entry point.
	'This is a good place to load resources that are not specific to a single activity.

End Sub

Sub Service_Start (StartingIntent As Intent)
	Service.StopAutomaticForeground 'Starter service can start in the foreground state in some edge cases.
End Sub

Sub Service_TaskRemoved
	'This event will be raised when the user removes the app from the recent apps list.
End Sub

'Return true to allow the OS default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy

End Sub

Public Sub GetBtwIdForProduct(rate As String) As String
	Dim lst As List
	lst.Initialize
	For i = 0 To lstBtw.Size -1
		Dim data As btwCursor
		data = lstBtw.Get(i)
		
		If rate = data.rate Then
			Return data.id
		End If
	Next
	Return "err"
End Sub

Public Sub GetBtwRateForProduct(id As String) As String
	Dim lst As List
	lst.Initialize
	For i = 0 To lstBtw.Size -1
		Dim data As btwCursor
		data = lstBtw.Get(i)
		
		If id = data.id Then
			Return data.rate
		End If
	Next
	Return "0"
End Sub

; Hosts Maker
; 自定义Hosts

#NoTrayIcon
#RequireAdmin
#include <Constants.au3>

#include <FileConstants.au3>

#include <GUIConstantsEx.au3>

Global $baseDir = @ScriptDir&"\"
Global $cfgFile = @ScriptDir&"\hosts.ini"
Global $newHost = @ScriptDir&"\hosts"
Global $defHost = @ScriptDir&"\hosts_default"
Global $sysHost = @WindowsDir&"\System32\drivers\etc\hosts"


; Editor

Func Editor()
    ;

    Local $eGUI = GUICreate("Editor", 630, 540)


    GUISetState(@SW_SHOW, $eGUI)




EndFunc   ;==>Editor



; #include <GUIConstantsEx.au3>
; #include <GuiToolbar.au3>
; #include <WindowsConstants.au3>

; Global $g_hToolbar, $g_idMemo
; Global $g_iItem ; Command identifier of the button associated with the notification.
; Global Enum $e_idSave = 1000

; ; Example()

; Func Example()
;     Local $hGUI, $aSize

;     ; Create GUI
;     $hGUI = GUICreate("Toolbar", 600, 400)
;     $g_hToolbar = _GUICtrlToolbar_Create($hGUI)
;     $aSize = _GUICtrlToolbar_GetMaxSize($g_hToolbar)

;     $g_idMemo = GUICtrlCreateEdit("", 2, $aSize[1] + 20, 596, 396 - ($aSize[1] + 20), $WS_VSCROLL)
;     GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
;     GUISetState(@SW_SHOW)
;     GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")

;     ; Add standard system bitmaps
;     _GUICtrlToolbar_AddBitmap($g_hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)

;     ; Add buttons
;     _GUICtrlToolbar_AddButton($g_hToolbar, $e_idSave, $STD_FILESAVE)

;     ; Loop until the user exits.
;     Do
;     Until GUIGetMsg() = $GUI_EVENT_CLOSE
; EndFunc   ;==>Example

; ; Write message to memo
; Func MemoWrite($sMessage = "")
;     GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
; EndFunc   ;==>MemoWrite

; ; WM_NOTIFY event handler
; Func _WM_NOTIFY($hWndGUI, $iMsgID, $wParam, $lParam)
;     #forceref $hWndGUI, $iMsgID, $wParam
;     Local $tNMHDR, $hWndFrom, $iCode, $iNew, $iFlags, $iOld
;     Local $tNMTBHOTITEM
;     $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
;     $hWndFrom = DllStructGetData($tNMHDR, "hWndFrom")
;     $iCode = DllStructGetData($tNMHDR, "Code")
;     Switch $hWndFrom
;         Case $g_hToolbar
;             Switch $iCode
;                 Case $NM_LDOWN
;                     ;----------------------------------------------------------------------------------------------
;                     MemoWrite("$NM_LDOWN: Clicked Item: " & $g_iItem & " at index: " & _GUICtrlToolbar_CommandToIndex($g_hToolbar, $g_iItem))
;                     ;----------------------------------------------------------------------------------------------
;                 Case $TBN_HOTITEMCHANGE
;                     $tNMTBHOTITEM = DllStructCreate($tagNMTBHOTITEM, $lParam)
;                     $iOld = DllStructGetData($tNMTBHOTITEM, "idOld")
;                     $iNew = DllStructGetData($tNMTBHOTITEM, "idNew")
;                     $g_iItem = $iNew
;                     $iFlags = DllStructGetData($tNMTBHOTITEM, "dwFlags")
;                     If BitAND($iFlags, $HICF_LEAVING) = $HICF_LEAVING Then
;                         MemoWrite("$HICF_LEAVING: " & $iOld)
;                     Else
;                         Switch $iNew
;                             Case $e_idSave
;                                 MemoWrite("$TBN_HOTITEMCHANGE: $e_idSave")
;                         EndSwitch
;                     EndIf
;             EndSwitch
;     EndSwitch
;     Return $GUI_RUNDEFMSG
; EndFunc   ;==>_WM_NOTIFY










; #include <AutoItConstants.au3>
; #include <MsgBoxConstants.au3>
#include <TrayConstants.au3> ; Required for the $TRAY_CHECKED and $TRAY_ICONSTATE_SHOW constants.

Opt("TrayMenuMode", 3) ; The default tray menu items will not be shown and items are not checked when selected. These are options 1 and 2 for TrayMenuMode.

; setTray()

Func setTray($sections)
    ; Create a tray item with the radio item parameter selected.

    If Not @error Then
       ; Enumerate through the array displaying the keys and their respective values.
       For $i = 1 To $sections[0][0]
            ; MsgBox($MB_SYSTEMMODAL, "", $sections[$i][0] & " " & $sections[$i][1] & @CRLF )
            TrayCreateItem($sections[$i][0])
            If $sections[$i][1] = 1 Then
                TrayItemSetState(-1, $TRAY_CHECKED)
            EndIf
       Next
    Else
        MsgBox($MB_SYSTEMMODAL, "", "[setTray]配置文件读取失败！")
    EndIf

    TrayCreateItem("") ; Create a separator line.

    Local $idRefresh = TrayCreateItem("刷新")
    TrayCreateItem("") ; Create a separator line.

    Local $idEditor = TrayCreateItem("编辑当前Hosts")
    TrayCreateItem("") ; Create a separator line.

    Local $idExit = TrayCreateItem("Exit")

    TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.

    ; MsgBox($MB_SYSTEMMODAL, "", "$TRAY_EVENT_NONE " & $TRAY_EVENT_NONE & @CRLF & $idExit)

    While 1
        Local $ID = TrayGetMsg()
        Select
            Case $ID <= 0
                ContinueLoop
            Case $ID == $idExit
                ExitLoop
            Case $ID == $idRefresh
                refreshConfig()
            Case $ID == $idEditor
                 Run("notepad.exe" & " " & $sysHost, "", @SW_SHOW)

            Case Else
                Local $txt = TrayItemGetText($ID)
                Local $state = TrayItemGetState($ID)

                If $txt <> "" Then
                    ; MsgBox($MB_SYSTEMMODAL, "", "id " & $ID)
                    ; MsgBox($MB_SYSTEMMODAL, "", $txt & ": " & $state)

                    ; MsgBox($MB_SYSTEMMODAL, "", BitAND($state, $TRAY_CHECKED) )

                    If BitAND($state, $TRAY_CHECKED) == 1 Then
                        TrayItemSetState($ID, $TRAY_UNCHECKED)
                        setINI($txt, 0)
                    Else
                        TrayItemSetState($ID, $TRAY_CHECKED)
                        setINI($txt, 1)
                    EndIf

                    refreshConfig()

                EndIf
        EndSelect

    WEnd
EndFunc   ;==>setTray






#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

getConfig()

Func getConfig()

    ; Read the INI section names. This will return a 1 dimensional array.
    Local $sections = getINI(0, "config")
    Local $data = ""

    ; Check if an error occurred.
    If Not @error Then
        ; Enumerate through the array displaying the section names.
        For $i = 1 To $sections[0][0]
            ; MsgBox($MB_SYSTEMMODAL, "", "Section: " & $sections[$i][0])
        Next
    EndIf


    ; Read the INI file for the value of 'Title' in the section labelled 'General'.

    If Not @error Then
       ; Enumerate through the array displaying the keys and their respective values.
       For $i = 1 To $sections[0][0]
            ; MsgBox($MB_SYSTEMMODAL, "", $sections[$i][0] & " " & $sections[$i][1] & @CRLF )
            If $sections[$i][1] = 1 Then
                Local $sH = getINI(2, $sections[$i][0])
                ; MsgBox($MB_SYSTEMMODAL, $sections[$i][0], $sH)
                $data &= "#" & $sections[$i][0] & @CRLF
                $data &= $sH & @CRLF
            EndIf
       Next
    Else
        MsgBox($MB_SYSTEMMODAL, "", "配置文件读取失败！")
    EndIf

    creatHost($data)

    FileCopy($newHost, $sysHost, $FC_OVERWRITE + $FC_CREATEPATH)

    setTray($sections)

EndFunc   ;==>getConfig


; 刷新配置
Func refreshConfig()

    ; Read the INI section names. This will return a 1 dimensional array.
    Local $sections = getINI(0, "config")
    Local $data = ""

    ; Check if an error occurred.
    If Not @error Then
        ; Enumerate through the array displaying the section names.
        For $i = 1 To $sections[0][0]
            ; MsgBox($MB_SYSTEMMODAL, "", "Section: " & $sections[$i][0])
        Next
    EndIf


    ; Read the INI file for the value of 'Title' in the section labelled 'General'.

    If Not @error Then
       ; Enumerate through the array displaying the keys and their respective values.
       For $i = 1 To $sections[0][0]
            ; MsgBox($MB_SYSTEMMODAL, "", $sections[$i][0] & " " & $sections[$i][1] & @CRLF )
            If $sections[$i][1] = 1 Then
                Local $sH = getINI(2, $sections[$i][0])
                ; MsgBox($MB_SYSTEMMODAL, $sections[$i][0], $sH)
                $data &= "#" & $sections[$i][0] & @CRLF
                $data &= $sH & @CRLF
            EndIf
       Next
    Else
        MsgBox($MB_SYSTEMMODAL, "", "配置文件读取失败！")
    EndIf

    creatHost($data)

    FileCopy($newHost, $sysHost, $FC_OVERWRITE + $FC_CREATEPATH)

    RunWait(@ComSpec & " /c ipconfig /flushdns", "", @SW_HIDE)

EndFunc   ;==>refreshConfig







; 0: 返回节点数组
; 1: 返回value数组
; 2: 返回key value
Func getINI($type, $secName)

    If $type = 0 Then
        Local $sections = IniReadSection($cfgFile, $secName)
        Return $sections
    EndIf

    If $type = 1 Then
        Local $aArray = IniReadSection($cfgFile, $secName)
        Local $aData[$aArray[0][0]]
        ; Check if an error occurred.
        If Not @error Then
           ; Enumerate through the array displaying the keys and their respective values.
           For $i = 1 To $aArray[0][0]
               ; MsgBox($MB_SYSTEMMODAL, "", $aArray[$i][0] & " " & $aArray[$i][1] & @CRLF )
               $aData[$i-1] = $aArray[$i][1]
           Next
        Else
            MsgBox($MB_SYSTEMMODAL, "", "配置文件读取失败！")
        EndIf

        Return $aData
    EndIf

    If $type = 2 Then
        Local $aArray = IniReadSection($cfgFile, $secName)
        Local $sData = ""
        ; Check if an error occurred.
        If Not @error Then
           ; Enumerate through the array displaying the keys and their respective values.
           For $i = 1 To $aArray[0][0]
               ; MsgBox($MB_SYSTEMMODAL, "", $aArray[$i][0] & " " & $aArray[$i][1] & @CRLF )
               $sData &= $aArray[$i][0] & " " & $aArray[$i][1] & @CRLF
           Next
        Else
            MsgBox($MB_SYSTEMMODAL, "", "配置文件读取失败！")
        EndIf

        Return $sData
    EndIf

    MsgBox($MB_SYSTEMMODAL, "", "[getINI]参数错误！")
EndFunc




Func creatHost($data)

    ; Open the file for reading and store the handle to a variable.
    Local $hFileOpen = FileOpen($newHost, 10)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
        Return False
    EndIf

    FileWrite($hFileOpen, $data)


    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)

EndFunc   ;==>creatHost


Func setINI($key, $value)

    IniWrite($cfgFile, "config", $key, $value)

EndFunc   ;==>setINI


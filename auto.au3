#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         pxuanbach

 Script Function:
	auto fishing PlayTogether

#ce ----------------------------------------------------------------------------
#include "FastFind.au3"
#include "HandleImgSearch.au3"
#include <WinAPI.au3>
DllCall("User32.dll","bool","SetProcessDPIAware")
HotKeySet('{ESC}','Thoat_Auto')
Opt("PixelCoordMode", 0)

$timerHndl = TimerInit()

$FFhWnd = WinGetHandle("0")
;Local $aClientSize = WinGetClientSize($FFhWnd)

FFSetWnd($FFhWnd)
FFSnapShot()
;FFSaveBMP('todo')


;While 1
;	FFSnapShot()
;	$aCoord = FFGetPixel(912, 301)
	;$aCoord = PixelGetColor(912, 301, $FFhWnd)
;	_HandleCreateInvRect($FFhWnd, 911, 300, 5, 5)
;	ConsoleWrite(Hex($aCoord) & @CRLF)
;WEnd

;Run

Sleep(100)
Select_Tool($FFhWnd)
While 1
	Fishing($FFhWnd)
	Store_Fish($FFhWnd)
WEnd

;EndRun


#cs
MsgBox(0, "", "PixelGetColor color returned : " & hex(PixelGetColor(200, 200, $FFhWnd)) & @CRLF & _
                 "FFGetPixel color returned : " & Hex(FFGetPixel(200, 200, 1)) & @CRLF & _
                 "MemoryReadPixel color returned : " & MemoryReadPixel(200, 200, $FFhWnd) )

MsgBox(0, "", "PixelGetColor average speed over 100 attempts : " & test_speed_PixelGetColor($FFhWnd) & " ms" & @CRLF & _
                 "FFGetPixel average speed over 100 attempts : " & test_speed_FFGetPixel($FFhWnd) & " ms" & @CRLF & _
                 "MemoryReadPixel average speed over 100 attempts : " & test_speed_MemoryReadPixel($FFhWnd) & " ms")
#ce

Func Select_Tool($WHnd)
	Sleep(1000)
	ControlClick($WHnd,'','','left',1,900,317) ;click bag
	Sleep(10)
	ControlClick($WHnd,'','','left',1,900,317) ;click bag
	ConsoleWrite('click bag'& @CRLF)
	Sleep(1500)
	ControlClick($WHnd,'','','left',1,692,70) ;click tool
	ConsoleWrite('click tool'& @CRLF)
	Sleep(1000)
	FFSnapShot()
	$aCoord = FFGetPixel(540, 195)
	ConsoleWrite($aCoord & @CRLF)
	If ($aCoord = 8583976) Then
		ControlClick($WHnd,'','','left',1,400, 429) ;close bag
		ConsoleWrite('close bag'& @CRLF)
		Sleep(1000)
	Else
		ControlClick($WHnd,'','','left',1,559,202) ;select tool 1
		ConsoleWrite('select tool 1'& @CRLF)
		Sleep(2000)
	EndIf

EndFunc

Func Fishing($WHnd)
	Sleep(1000)
	ControlClick($WHnd,'','','left',1,755,330) ;click fishing
	Sleep(10)
	ControlClick($WHnd,'','','left',1,755,330) ;click fishing
	ConsoleWrite('click fishing'& @CRLF)
	Check_Repair_Tool($WHnd)
	Sleep(15000)
	ConsoleWrite('Start' & @CRLF)
	Local $aCoord1, $aCoord2, $aCoord3
	While 1
		FFSnapShot()
		$aCoord1 = FFGetPixel(483, 51)
		$aCoord2 = FFGetPixel(475, 51)
		$aCoord3 = FFGetPixel(467, 51)

		_HandleCreateInvRect($WHnd, 467, 50, 16, 5)
		If ($aCoord1 = 16777215) Or ($aCoord2 = 16777215) Or ($aCoord3 = 16777215) Then
			For $i = 1 To 30
				ControlClick($WHnd,'','','left',1,835,422)
				Sleep(20)
			Next
			Sleep(1000)
			ExitLoop
		EndIf
	WEnd
EndFunc

Func Store_Fish($WHnd)
	Sleep(4000)
	ConsoleWrite('check store'& @CRLF)
	While 1
		FFSnapShot()
		$aCoordStore = FFGetPixel(645, 440)
		$aCoordShare = FFGetPixel(845, 440)
		If ($aCoordStore = 4310515) And ($aCoordShare = 16762653) Then
			ControlClick($WHnd,'','','left',1,665, 420) ;click store
			ConsoleWrite('clicked' & @CRLF)
			Sleep(2000)
			ExitLoop
		EndIf
	WEnd
EndFunc

Func Check_Repair_Tool($WHnd)
	;bag: color 14893121 (912, 301)
	Sleep(2000)
	FFSnapShot()
	$aCoord = FFGetPixel(912, 301)
	ConsoleWrite('check repair tool'& @CRLF)
	If ($aCoord = 14893121) Then
		Repair_Tool($WHnd)
	EndIf
EndFunc

Func Repair_Tool($WHnd)
	Sleep(1000)
	ControlClick($WHnd,'','','left',1,900,317) ;click bag
	Sleep(10)
	ControlClick($WHnd,'','','left',1,900,317) ;click bag
	ConsoleWrite('click bag'& @CRLF)
	Sleep(1000)
	ControlClick($WHnd,'','','left',1,692,70) ;click tool
	ConsoleWrite('click tool'& @CRLF)
	Sleep(1000)
	FFSnapShot()
	Local $aCoord = FFGetPixel(547, 286)
	ConsoleWrite('repair' & @CRLF)
	If ($aCoord = 15818318) Then
		ControlClick($WHnd,'','','left',1,580, 270) ;click repair
		ConsoleWrite('click repair'& @CRLF)
		Sleep(1000)
		ControlClick($WHnd,'','','left',1,483, 429) ;click pay
		ConsoleWrite('click pay'& @CRLF)
		Sleep(2000)
		ControlClick($WHnd,'','','left',1,483, 429) ;click yes
		ConsoleWrite('click yes'& @CRLF)
		Sleep(1000)
		ControlClick($WHnd,'','','left',1,400, 429) ;close bag
		ConsoleWrite('close bag'& @CRLF)
		Sleep(1000)
	Else
		ControlClick($WHnd,'','','left',1,400, 429) ;close bag
		ConsoleWrite('close bag'& @CRLF)
		Sleep(1000)
	EndIf
EndFunc

Func Thoat_Auto()
	Exit
EndFunc

Func _WinAPI_DrawRect($start_x, $start_y, $end_x, $end_y, $iColor)
    Local $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
    Local $tRect = DllStructCreate($tagRECT)
    DllStructSetData($tRect, 1, $start_x)
    DllStructSetData($tRect, 2, $start_y)
    DllStructSetData($tRect, 3, $end_x)
    DllStructSetData($tRect, 4, $end_y)
    Local $hBrush = _WinAPI_CreateSolidBrush($iColor)

    _WinAPI_FrameRect($hDC, DllStructGetPtr($tRect), $hBrush)

    ;clear resources
    _WinAPI_DeleteObject($hBrush)
    _WinAPI_ReleaseDC(0, $hDC)
EndFunc ;==>_WinAPI_DrawRect

Func _HandleCreateInvRect($hWnd, $iX, $iY, $iW, $iH)
    $aPos = WinGetPos($hWnd)

	_WinAPI_DrawRect($aPos[0] + $iX, $aPos[1] + $iY, $aPos[0] + $iX + $iW, $aPos[1] + $iY + $iH, 0xFF0000)
EndFunc

#cs
Func MemoryReadPixel($x, $y, $handle)
   Local $hDC
   Local $iColor
   Local $sColor

   $hDC = _WinAPI_GetWindowDC($handle)
   $iColor = DllCall("gdi32.dll", "int", "GetPixel", "int", $hDC, "int", $x, "int", $y)
   $sColor = Hex($iColor[0], 6)
   _WinAPI_ReleaseDC($handle, $hDC)

   Return Hex("0x" & StringRight($sColor, 2) & StringMid($sColor, 3, 2) & StringLeft($sColor, 2))
EndFunc ;==>MemoryReadPixel

Func test_speed_MemoryReadPixel($param1)
   Local $count = 0

   For $i = 1 To 100
      $timer = TimerDiff($timerHndl)
      $color = MemoryReadPixel(200, 200, $param1)
      $timer = TimerDiff($timerHndl) - $timer

      $count += $timer
      Sleep(10)
   Next

   Return($count / 100)
EndFunc ;==>test_speed_MemoryReadPixel

Func test_speed_FFGetPixel($param1)
   Local $count = 0

   FFSnapShot(380, 37, 565, 77, 1, $param1)
	;FFSaveBMP("TOTO")
   For $i = 1 To 100
      $timer = TimerDiff($timerHndl)
      $color = Hex(FFGetPixel(0, 0, 1))
      $timer = TimerDiff($timerHndl) - $timer

     $count += $timer
     Sleep(10)
   Next

   Return($count / 100)
EndFunc ;==>test_speed_FFGetPixel

Func test_speed_PixelGetColor($param1)
   Local $count = 0

   For $i = 1 To 100
      $timer = TimerDiff($timerHndl)
      $color = Hex(PixelGetColor(200, 200, $param1))
      $timer = TimerDiff($timerHndl) - $timer

      $count += $timer
      Sleep(10)
   Next

   Return($count / 100)
EndFunc ;==>test_speed_PixelGetColor
#ce
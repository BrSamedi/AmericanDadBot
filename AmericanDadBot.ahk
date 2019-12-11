#SingleInstance force
#include <Vis2>
#include <findText>
#include <Gdip_All>
#Include <Gdip_ImageSearch>
Position := [{ID: 1, X: 894, Y: 72, Power: 9999999, Attacked: 1}
,{ID: 2, X: 724, Y: 245, Power: 9999999, Attacked: 1}
,{ID: 3, X: 1075, Y: 245, Power: 9999999, Attacked: 1}
,{ID: 4, X: 604, Y: 426, Power: 9999999, Attacked: 1}
,{ID: 5, X: 913, Y: 426, Power: 9999999, Attacked: 1}
,{ID: 6, X: 1219, Y: 426, Power: 9999999, Attacked: 1}
,{ID: 7, X: 457, Y: 595, Power: 9999999, Attacked: 1}
,{ID: 8, X: 759, Y: 595, Power: 9999999, Attacked: 1}
,{ID: 9, X: 1066, Y: 595, Power: 9999999, Attacked: 1}
,{ID: 10, X: 1370, Y: 595, Power: 9999999, Attacked: 1}
,{ID: 11, X: 308, Y: 764, Power: 9999999, Attacked: 1}
,{ID: 12, X: 611, Y: 764, Power: 9999999, Attacked: 1}
,{ID: 13, X: 913, Y: 764, Power: 9999999, Attacked: 1}
,{ID: 14, X: 1215, Y: 764, Power: 9999999, Attacked: 1}
,{ID: 15, X: 1520, Y: 764, Power: 9999999, Attacked: 1}]
MyPower := 0
MyPosition := 0
mode := 1
IniRead, mode, settings.ini, global, mode
collectfood := 1
IniRead, collectfood, settings.ini, global, collectfood
ratio := 1.1
IniRead, ratio, settings.ini, arena, ratio
participate := 0
IniRead, participate, settings.ini, arena, participate
timer := 5000
IniRead, timer, settings.ini, arena, timer
timer := timer*1000
screenshot := 0
IniRead, screenshot, settings.ini, arena, screenshot
alwaysOnTop := 0
IniRead, alwaysontop, settings.ini, antibot, alwaysontop
alarm := 0
IniRead, alarm, settings.ini, antibot, alarm

CoordMode Pixel
WinWait, NoxPlayer
WinMove, 0, 0
IfWinNotActive, NoxPlayer
{
	WinActivate, NoxPlayer
}
WinSet, Style, -0x20000, NoxPlayer
WinSet, Style, -0x10000, NoxPlayer

Sleep, 1000

pToken := Gdip_Startup()
Loop {
	MainScreen()
	if collectfood = 1
	CollectFood()
	GoToArena()
	MyPower := StartArena(participate)
	WaitArena()

	NPosition := 1
	EnemyNumber := 0
	EnemyCount := 14
	Phase := 1
	Loop
	{
		if WaitArenaEnd() = 1
		break
		if (EnemyNumber = EnemyCount)
		{
			WeakEnemy := FindWeakEnemy(Position, Phase, MyPosition, ratio)
			Fight(Position,WeakEnemy)
			PrepareToRound(Position)
			AntiBotCheck(alwaysOnTop, alarm)
			WaitArena()
			Phase++
			EnemyNumber := 0
			EnemyCount--
		}
		AntiBotCheck(alwaysOnTop, alarm)
		ReadEnemy(Position,NPosition,838, 430, 200, 12)
		if Position[NPosition].Attacked = 0
		EnemyNumber++
		if NPosition = 15
		NPosition = 1
		else
		NPosition++
	}
	if timer = 0
	Random, timer, 120000, 300000
	Sleep, %timer%
}


AntiBotCheck(alwaysOnTop, alarm)
{
	color := BotPixelGetColor(509, 440)
	while color = 0x3C4245
	{
		if alwaysOnTop = 1
		WinActivate, NoxPlayer
		if alarm = 1
		SoundBeep , 300 ,300
		Sleep, 1000
		color := BotPixelGetColor(509, 440)
	}
}

WaitArenaEnd()
{	
	global screenshot
	color := BotPixelGetColor(1562, 63)
	if color = 0x5C4D56
	{
		if screenshot = 1 
		{
			Sleep, 5000
			TakeScreenShot()
		}
		Sleep, 1000
		BotClick(left, 1566, 237)
		Sleep, 1000
		return 1
	}
	else
	return 0
}

WaitArena()
{
	color := BotPixelGetColor(1576, 232)
	while color != 0x69FF61
	{
		AntiBotCheck(alwaysOnTop, alarm)
		Sleep, 1000
		color := BotPixelGetColor(1576, 232)
	}
	Sleep, 5000
}

Fight(ByRef arr, WeakEnemy)
{
	BotClick(left, arr[WeakEnemy].X, arr[WeakEnemy].Y)
	Sleep, 1000
	BotClick(left, 1172, 772)
	Sleep, 1000
	color := BotPixelGetColor(866,851)
	while color != 0x69FF61
	{
		Sleep, 3000
		color := BotPixelGetColor(866,851)
	}
	BotClick(left, 866,851)
	Sleep, 3000
}

MainScreen()
{
	color := BotPixelGetColor(1540,570)
	while color != 0x0C60AA
	{
		ControlSend, ,{Esc}, NoxPlayer
		Sleep, 1000
		color := BotPixelGetColor(1540,570)
	}


}

CollectFood()
{
	global pToken
	WinGet, hwnd, ID, NoxPlayer
	bmpNox := Gdip_BitmapFromHWND(hwnd)
	TryToCollect := ["alien", "ghost", "fire", "pie"]
	Loop % TryToCollect.Length()
	{	
		pict := % TryToCollect[A_Index]
		ImgPath = %A_WorkingDir%\images\%pict%.png
		bmpTryToCollect := Gdip_CreateBitmapFromFile(ImgPath)
		RET := Gdip_ImageSearch(bmpNox,bmpTryToCollect,LIST,0,0,0,0,0,0xFFFFFF,1,0)
		Gdip_DisposeImage(bmpTryToCollect)
		word_array := StrSplit(LIST, ",")
		ps1 := "x"+word_array[1]
		ps1 .= " y"+word_array[2]
		ControlClick,% ps1, NoxPlayer
		Sleep, 1000
	}
	Gdip_DisposeImage(bmpNox)
}

CollectResources()
{
	Loop,
	{
		t1:=A_TickCount

		TextGhost:="|<>*109$30.0Q3U00U0k010A8030O80D0k4My1U7y41U4240U0340U0323k0226Dk61A3w40s1yDUM1y1QM0a07s0w07c0w24A0s6440Tw46000A20008100080k0080M00A0701U"
		if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, TextGhost))
		{
			for i,v in ok
			if (i<=1)
			BotClick(left, v.1+v.3//2, v.2+v.4//2)
			Sleep, 1000
		}

		TextAlien:="|<>*129$46.w000000yE7U0T06tUn0360Hny608A3/7kA1UMsi00QA0y6Q0szVs0NkDswDk3ZVUU3VUAHs30A21l7061UAx600AA0S4800TU00m"
		if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, TextAlien))
		{
			for i,v in ok
			if (i<=1)
			BotClick(left, v.1+v.3//2, v.2+v.4//2)
			Sleep, 1000
		}

		TextFire:="|<>*165$35.zzUT01zzUT03zzUT07zzUP0DzzUX0TzzV30zzz4/1zzzGH3zzzg37zzyGH7zzt937zzU2H7zyF8i7zt4GQ7zYF8s7wl4Hk7W4F7U60l4T066A1y07Ul3w066A3s06kk3k06323U06s830061UX"
		if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, TextFire))
		{
			for i,v in ok
			if (i<=1)
			BotClick(left, v.1+v.3//2, v.2+v.4//2)
			Sleep, 1000
		}


		TextFood:="|<>*115$28.Ds03Xzk1zA40Ty003zw00Tzs03zz03zzw08zvk83z71UDsA00zkw01zjU07zw00Dzi00TwTU0T060008"
		if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, TextFood))
		{
			for i,v in ok
			if (i<=1)
			BotClick(left, v.1+v.3//2, v.2+v.4//2)
			Sleep, 1000
		}
		else
		break
	}
	Sleep, 3000
	BotClick(left, 802, 278)
}


GoToArena()
{
	BotClick(left, 110, 810)
	Sleep, 1000
	BotClick(left, 1374, 330)
	Sleep, 1000
}

StartArena(choice)
{
	if (choice != 1)
	BotClick(left, 300, 320)
	;ticketCount := ReadPower(700,185,55,3)
	ticketCount := ReadPower(700,185,65,-10)
	;foodCount := ReadPower(420,185,113,3)
	foodCount := ReadPower(400,185,133,-10)
	foodNeed := ReadPower(374,744,139,5)
	if (choice = 0 && foodCount > foodNeed)
	BotClick(left, 300, 320)
	else if (choice = 1 && ticketCount > 1)
	BotClick(left, 540, 320)
	else if (choice = 2 && foodCount > foodNeed)
	BotClick(left, 300, 320)
	else if (choice = 2 && ticketCount > 1)
	BotClick(left, 540, 320)
	else if (choice = 3 && ticketCount > 1)
	BotClick(left, 540, 320)
	else if (choice = 3 && foodCount > foodNeed)
	BotClick(left, 300, 320)
	else
	{
		MsgBox, Not enough resourses
		ExitApp
	}
	Sleep, 1000
	BotClick(left, 420, 740)
	Sleep, 1000
	power := ReadPower(780, 201, 200, 10)
	Sleep, 1000
	BotClick(left, 1207, 838)
	return power
}

ReadEnemy(ByRef arr,n,x,y,w,h)
{
	global MyPower,MyPosition
	color := BotPixelGetColor(arr[n].X, arr[n].Y)
	counter := 0
	while (color != 0xFFFFFF && counter<10)
	{
		Sleep, 1000
		color := BotPixelGetColor(arr[n].X, arr[n].Y)
		counter++
	}
	BotClick(left, arr[n].X, arr[n].Y)
	Sleep, 1000
	global pToken
	WinGet, hwnd, ID, NoxPlayer
	closeBtn = %A_WorkingDir%\images\close.png
	bmpNox := Gdip_BitmapFromHWND(hwnd)
	bmpClose := Gdip_CreateBitmapFromFile(closeBtn)
	RET := Gdip_ImageSearch(bmpNox,bmpClose,LIST,0,0,0,0,0,0xFFFFFF,1,0)
	if RET = 1
	{
		arr[n].Power := ReadPower(x,y,w,h)
		counter := 0
		while (arr[n].Power<=1000 && counter<5)
		{
			arr[n].Power := ReadPower(x,y,w,h)
			Sleep, 1000
			counter++
		}
		Sleep, 1000
		color := BotPixelGetColor(1183, 747)
		if (color = 0x69FF61  or color = 0xD2FFEA)
		arr[n].Attacked := 0
		else
		arr[n].Attacked := 1
		word_array := StrSplit(LIST, ",")
		ps1 := "x"+word_array[1]
		ps1 .= " y"+word_array[2]
		BotClick(left, word_array[1], word_array[2])
	}
	Else
	{
		arr[n].Power := MyPower
		MyPosition := n
		arr[n].Attacked := 1
	}
	Gdip_DisposeImage(bmpClose)
	Gdip_DisposeImage(bmpNox)
	Sleep, 1000
	return arr[n].Power
}
ReadPower(x,y,w,h)
{
	global pToken
	WinGet, hwnd, ID, NoxPlayer
	bmpHaystack := Gdip_BitmapFromScreen("hwnd:" hwnd)
	pCroppedBitmap := Gdip_CropBitmap(bmpHaystack, x, 1600-x-w, y, 900-y-h, 0) 
	try 
	{
		power := OCR(pCroppedBitmap)
	}
	Catch e
	{
		Gdip_SaveBitmapToFile(pCroppedBitmap, "error.png")	
		MsgBox, An exception was thrown!`nSpecifically: %e%
		Exit
	}
	Gdip_DisposeImage(pCroppedBitmap)
	Gdip_DisposeImage(bmpHaystack)
	StringReplace, power, power, % " ",, 1 
	power += 0 
	return power+0
}

FindWeakEnemy(ByRef arr, Phase, MyPosition,ratio)
{
	global MyPower
	arrNew := []
	enemy=0
	key := "Power"
	str := "", d := Chr(1)
	for k, v in arr
	str .= (str = "" ? "" : d) . v[key] . "~" . k
	Sort, str, % "ND" . d
	Loop, parse, str, % d
	arrNew.Push(arr[ RegExReplace(A_LoopField, ".+~") ])

	if Phase <4
	{
		for k, v in arrNew
		{
			if v.ID > MyPosition && v.Attacked = 0
			{
				enemy := v.ID
				break
			}
		}
	}
	else
	{
		for k, v in arrNew
		{
			if v.ID < MyPosition && v.Attacked = 0 && v.Power < MyPower*ratio
			{
				enemy := v.ID
				break
			}
		}
	}
	if enemy = 0
	{
		for k, v in arrNew
		{
			if v.Attacked = 0
			{
				enemy := v.ID
				break
			}
		}
	}
	return enemy
}

PrepareToRound(ByRef arr)
{
	for k, v in arr
	{
		v.Power := 9999999
		v.Attacked := 1
	}
}

WriteArrayInFile(ByRef arr, filename)
{ 
	for k, v in arr
	{
		str := "ID: " + v.ID
		str.=  ", X: " + v.X
		str.=  ", Y: " + v.Y
		str.=  ", Power: " + v.Power
		str.=  ", Attacked: " + v.Attacked
		str.=   "`n"
		FileAppend,  %str%, %filename%
	}
}


BotClick(btn, x1, y1)
{
	global mode
	if mode = 1
	ControlClick, x%x1% y%y1%, NoxPlayer
	else
	{

		WinActivate, NoxPlayer
		MouseClick, %btn%, x1, y1
	}
}

BotPixelGetColor(x1, y1)
{
	global mode
	if mode = 1
	{
		global pToken
		WinGet, hwnd, ID, NoxPlayer
		bmpHaystack := Gdip_BitmapFromScreen("hwnd:" hwnd)
		ARGB := GDIP_GetPixel(bmpHaystack, x1, y1)

		setformat,integer,hex
		ARGB +=0

		Gdip_DisposeImage(bmpHaystack)
		ARGB := Format("0x{:06X}", ARGB & 0xFFFFFF)
		ARGB :="0x" . SubStr(ARGB, 7, 2) . SubStr(ARGB, 5, 2) . SubStr(ARGB, 3, 2)
		setformat,integer,d
	}
	else
	{
		WinActivate, NoxPlayer
		PixelGetColor, ARGB, x1, y1
	}
	return ARGB

}

Gdip_CropBitmap(pBitmap, left, right, up, down, Dispose=1) {
	Gdip_GetImageDimensions(pBitmap, origW, origH)
	NewWidth := origW-left-right, NewHeight := origH-up-down
	pBitmap2 := Gdip_CreateBitmap(NewWidth, NewHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2), Gdip_SetSmoothingMode(G2, 4), Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap, 0, 0, NewWidth, NewHeight, left, up, NewWidth, NewHeight)
	Gdip_DeleteGraphics(G2)
	if Dispose
	Gdip_DisposeImage(pBitmap)
	return pBitmap2
}

TakeScreenShot()
{
	FormatTime, TimeString, ,ddMMyyHHmmss
	global pToken
	WinGet, hwnd, ID, NoxPlayer
	bmpHaystack := Gdip_BitmapFromScreen("hwnd:" hwnd)
	IfNotExist, screenshots 
	FileCreateDir, screenshots
	Gdip_SaveBitmapToFile(bmpHaystack, "screenshots\" . TimeString . ".png")

	Gdip_DisposeImage(bmpHaystack)
}
Gdip_Shutdown(pToken)

RandomSleep(min,max)
{
	Random, random, %min%, %max%
	Sleep %random%
}

ExitApp

^!p::Pause
^!q::ExitApp
#Requires AutoHotkey v2.0
; --- Robust IME ON/OFF with debug logging for Google Japanese Input ---
SetKeyDelay 20
SendMode "Event"

; ===== Debug settings =====
global DEBUG := false
global LOG_FILE := A_ScriptDir "\ime_debug.log"

Log(msg) {
    if (!DEBUG)
        return
    ts := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
    line := ts " - " msg "`n"
    try FileAppend(line, LOG_FILE, "UTF-8")
    try OutputDebug(line)
    ToolTip(msg, 10, 10)
    SetTimer(() => ToolTip(), -800)
}

; ===== Public hotkeys =====
; Fixed language switch
CapsLock & ,::IME_Force(0)   ; force English (IME OFF)
CapsLock & .::IME_Force(1)   ; force Japanese (IME ON)

; Keep CapsLock as modifier only
; --- keep CapsLock always OFF (strongest) ---
SetCapsLockState "AlwaysOff"

; --- block both down and up events of CapsLock ---
*CapsLock::Return
*CapsLock up::Return

; Your other mappings
CapsLock & i::Send "{Up}"
CapsLock & j::Send "{Left}"
CapsLock & k::Send "{Down}"
CapsLock & l::Send "{Right}"
CapsLock & u::Send "{Home}"
CapsLock & SC027::Send "{End}"   ; ";" by scancode
CapsLock & h::Send "{Backspace}"
CapsLock & g::Send "-"           ; Minus
CapsLock & f::Send "{Enter}"
CapsLock & /::Send "{Delete}"
CapsLock & p::Send "{PrintScreen}"

; ===== Debug helper hotkeys =====
CapsLock & q::ShowIMEStatus()     ; show current IME status
CapsLock & r::Reload              ; quick reload
CapsLock & t::
{
    global DEBUG, LOG_FILE
    DEBUG := !DEBUG
    msg := "DEBUG " (DEBUG ? "ON" : "OFF")
    ts := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
    try FileAppend(ts " - " msg "`n", LOG_FILE, "UTF-8")
    ToolTip(msg, 10, 10)
    SetTimer(() => ToolTip(), -800)
}

ShowIMEStatus() {
    st := IME_GetStatus()
    if (st = 1) {
        Log("IME status: ON")
    } else if (st = 0) {
        Log("IME status: OFF")
    } else {
        Log("IME status: UNKNOWN (" st ")")
    }
}

; ===== IME control (3-step with logging) =====
IME_Force(state) {
    Log("IME_Force request: " (state ? "ON" : "OFF"))
    ; Try #1
    if IME_Set_OpenStatus_ByImm32(state) {
        curr := IME_GetStatus()
        Log("Success by Imm32. Now: " (curr ? "ON" : "OFF"))
        return
    } else {
        Log("Imm32 method failed or not available.")
    }
    ; Try #2
    if IME_Set_OpenStatus_ByMsg(state) {
        curr := IME_GetStatus()
        Log("Success by WM_IME_CONTROL. Now: " (curr ? "ON" : "OFF"))
        return
    } else {
        Log("WM_IME_CONTROL method failed.")
    }
    ; Try #3 fallback
    IME_SendFallback(state)
    Sleep 20
    curr := IME_GetStatus()
    Log("Fallback sent (" (state ? "Henkan" : "Muhenkan") "). Now: " (curr=1?"ON":curr=0?"OFF":"UNKNOWN"))
}

; Try #1: ImmSetOpenStatus via imm32.dll
IME_Set_OpenStatus_ByImm32(state) {
    hwnd := DllCall("GetForegroundWindow", "ptr")
    Log("Imm32: hwnd=" hwnd)
    if !hwnd
        return false
    hIMC := DllCall("imm32\ImmGetContext", "ptr", hwnd, "ptr")
    Log("Imm32: hIMC=" hIMC)
    if !hIMC
        return false
    ok := DllCall("imm32\ImmSetOpenStatus", "ptr", hIMC, "int", state, "int")
    DllCall("imm32\ImmReleaseContext", "ptr", hwnd, "ptr", hIMC)
    Log("Imm32: ImmSetOpenStatus returned " ok)
    return ok != 0
}

; Try #2: WM_IME_CONTROL / IMC_SETOPENSTATUS
IME_Set_OpenStatus_ByMsg(state) {
    hwnd := DllCall("GetForegroundWindow", "ptr")
    Log("Msg: hwnd=" hwnd)
    if !hwnd
        return false
    imeWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "ptr", hwnd, "ptr")
    Log("Msg: imeWnd=" imeWnd)
    if !imeWnd
        return false
    WM_IME_CONTROL := 0x283
    IMC_SETOPENSTATUS := 0x006
    r := DllCall("User32\SendMessageW", "ptr", imeWnd, "uint", WM_IME_CONTROL, "uptr", IMC_SETOPENSTATUS, "ptr", state, "ptr")
    Log("Msg: SendMessage returned " r)
    Sleep 10
    curr := IME_GetStatus()
    Log("Msg: readback status=" curr)
    return (curr = state)
}

; Read IME open status
IME_GetStatus() {
    hwnd := DllCall("GetForegroundWindow", "ptr")
    if !hwnd
        return -1
    hIMC := DllCall("imm32\ImmGetContext", "ptr", hwnd, "ptr")
    if !hIMC
        return -1
    status := DllCall("imm32\ImmGetOpenStatus", "ptr", hIMC, "int")
    DllCall("imm32\ImmReleaseContext", "ptr", hwnd, "ptr", hIMC)
    return status
}

; Try #3: send Muhenkan/Henkan (requires GJI keymap: NonConvert=IME Off, Convert=IME On)
IME_SendFallback(state) {
    if (state = 0) {
        Send "{NonConvert}"
        Send "{vk1D}"     ; reinforce on some layouts
        Log("Fallback: sent NonConvert (IME OFF)")
    } else {
        Send "{Convert}"
        Send "{vk1C}"
        Log("Fallback: sent Convert (IME ON)")
    }
}

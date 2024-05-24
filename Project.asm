.386
.model flat, stdcall
.stack 4096
INCLUDE irvine32.inc
ExitProcess PROTO, dwExitCode:DWORD
Bus Struct
Bus_Id Dword ?
Bus_Route Dword ?
Bus Ends

.data
Buses Bus 20 Dup(<0,0>)
Total_Buses Dword ? 
msgNum Byte 0dh,0ah,"Enter Bus Number :",0
msgRoute Byte 0dh,0ah,"Enter Bus route :",0
insertError Byte 0dh,0ah,"Bus Not Available",0
msgBusNo BYTE 0dh,0ah,"BUS NO is : ",0
msgBusRoute BYTE 0dh,0ah,"BUS ROUTE is : ",0
.code
main PROC
   call insert
   call DisplayAll
    exit
main ENDP

insert Proc
    mov edx,offset msgNum
    call writeString
    call readDec
    mov ebx,eax
 mov edx,offset msgRoute
    call writeString
    call readDec
    mov esi,offset Buses
    mov ecx,20
    findSpace:
    cmp [esi].Bus.Bus_Id,0
    je Found
    add esi,Type Bus
    loop findspace

        jmp notfound

    found:
    mov [esi].Bus.Bus_Id,ebx
     mov [esi].Bus.Bus_Route,eax
     jmp exitInsert

    notfound:
     mov edx,offset insertError
    call writeString
    exitinsert:
insert EndP

DisplayAll Proc
mov ecx,20
mov esi,offset Buses
DisplayLoop:
cmp [esi].Bus.Bus_id,0
jne Print
jmp ignoreD
Print:
mov edx,offset msgBusNo
call WriteString
mov eax,[esi].Bus.Bus_Id
call WriteDec
mov edx,offset msgBusRoute
call WriteString
mov eax,[esi].Bus.Bus_Route
call WriteDec
ignoreD:
add esi,Type Bus
loop Displayloop
DisplayAll EndP

END main

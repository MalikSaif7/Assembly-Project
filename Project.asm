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

msg1 BYTE   "**press 1 for insert**: ",0dh,0ah, "**press 2 for displayall**: ", 0dh,0ah, "**press 3 for search**: ", 0dh,0ah, "**press 4 for deleteBus**: ",0
msgNum Byte 0dh,0ah,"Enter Bus Number :",0
msgRoute Byte 0dh,0ah,"Enter Bus route :",0
insertError Byte 0dh,0ah,"Bus Not Available",0
msgBusNo BYTE 0dh,0ah,"BUS NO is : ",0
msgBusRoute BYTE 0dh,0ah,"BUS ROUTE is : ",0
msgSearch BYTE 0dh,0ah,"ENTER BUS NUMBER TO SEARCH : ",0
msgDelete BYTE 0dh,0ah,"ENTER BUS NUMBER TO Delete : ",0
msgFound BYTE 0dh,0ah,"BUS FOUND WITH BUS_ID : ",0
msgInvalid BYTE "You entered Invalid Value : ",0
msgloop Byte 0ah,0dh,"Press y to try again: ",0
.code

main PROC
loopl:
    call crlf
    mov edx, offset msg1
    call writestring
    call readDec
    cmp eax,1
    je LabelInsert
    cmp eax,4
    je LabelDelete
    cmp eax,2
    je LabelDisplayALL
    cmp eax,3
    je labelsearch
    jmp invalidValue
 labelInsert:
     call insert
 jmp exitlabel
  labelDelete:
    call DeleteBus
 jmp exitlabel
   labelDisplayAll:
    call DisplayAll
 jmp exitlabel
   labelSearch:
    call search
 jmp exitlabel


   invalidValue:
   mov edx,offset msgInvalid
   call WriteString
 

 exitlabel:
 mov edx,offset msgloop
 call writeString
 call readChar
 cmp al,'y'
 je loopl
  cmp al,'Y'
 je loopl
    invoke ExitProcess, 0
main ENDP

insert PROC                                   
    mov edx, offset msgNum                     
    call WriteString                          
    call ReadDec                              
    mov ebx, eax                               
    mov edx, offset msgRoute                                                        
    call WriteString                          
    call ReadDec                              
    mov esi, offset Buses                      
    mov ecx, 20                                
    
findSpace:
    cmp [esi].Bus.Bus_Id, 0                    
    je  Found                                  
    add esi, TYPE Bus                          
    loop findSpace                                                                 
    jmp notfound                                                                
    
Found:
    mov [esi].Bus.Bus_Id, ebx
    mov [esi].Bus.Bus_Route, eax
    jmp exitInsert

notfound:
    mov edx, offset insertError
    call WriteString

exitInsert:
    ret
insert ENDP

DisplayAll PROC
    mov ecx, 20
    mov esi, offset Buses

DisplayLoop:
    cmp [esi].Bus.Bus_Id, 0
    jne Print
    jmp ignoreD

Print:
    mov edx, offset msgBusNo
    call WriteString
    mov eax, [esi].Bus.Bus_Id
    call WriteDec
    mov edx, offset msgBusRoute
    call WriteString
    mov eax, [esi].Bus.Bus_Route
    call WriteDec

ignoreD:
    add esi, TYPE Bus
    loop DisplayLoop

    ret
DisplayAll ENDP

search PROC
    mov edx, offset msgSearch
    call WriteString
    call ReadDec
    mov ebx, eax
    mov esi, offset Buses
    mov ecx, 20

searchLoop:
    cmp [esi].Bus.Bus_Id, ebx
    je Foundd
    add esi, TYPE Bus
    loop searchLoop

    jmp notfoundd

Foundd:
    mov edx, offset msgFound
    call WriteString
    mov eax, [esi].Bus.Bus_Id
    call WriteDec
      mov edx, offset msgBusRoute
    call WriteString
    mov eax, [esi].Bus.Bus_Route
    call WriteDec
    jmp exitsearch

notfoundd:
    mov edx, offset insertError
    call WriteString

exitsearch:
    ret
search ENDP


DeleteBus PROC
    mov edx, offset msgDelete
    call WriteString
    call ReadDec
    mov ebx, eax
    mov esi, offset Buses
    mov ecx, 20

searchLoop:
    cmp [esi].Bus.Bus_Id, ebx
    je Foundd
    add esi, TYPE Bus
    loop searchLoop

    jmp notfoundd

Foundd:
    mov [esi].Bus.Bus_Id,0   
    mov [esi].Bus.Bus_Route,0
    jmp exitsearch

notfoundd:
    mov edx, offset insertError
    call WriteString

exitsearch:
    ret
DeleteBus ENDP

END main

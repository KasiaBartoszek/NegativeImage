; Autor: Katarzyna Bartoszek
; Temat projektu: Negatyw bitmapy
; Przedmiot: JA
; Rok akademicki: 2019/2020
; Grupa: 1
; Sekcja: 1
; Prowadz�cy: OA

.DATA
_max dd 255 ; maksymalna warto�� koloru
.CODE
NegativeBitmap PROC a: DWORD, b: DWORD, s: DWORD, e: DWORD ; b - wska�nik na pocz�tek bitmapy, s - pocz�tkowy indeks tablicy, e - ko�cowy indeks tablicy
	PUSH RSI ; pocz�tek stosu, zapis oryginalnej warto�ci RSI
	MOV RSI, R8 ; przenie� do RSI wska�nik do tablicy znajduj�cy si� w rejestrze R8
	MOV EAX, DWORD PTR s ; przenie� warto�� argumentu "start" (pocz�tek bitmapy) do EAX
	ADD RSI,  RAX ; przenie� nag��wek b�d�cy pocz�tkiem bitmapy (o warto�ci 54) do RSI (to, co jest w EAX znajduje si� r�wnie� w RAX)
	MOV DWORD PTR e, EBX ; zapisz koniec bitmapy z okna rejestru EBX do parametru "e"
	VMOVD XMM0, [_max] ; wpisz warto�� maksymaln� koloru (255) do XMM0
	VPBROADCASTB XMM0, XMM0 ; powiel warto�� byte rejestru XMM0 na wszystkich pozycjach byte
NegativeLoop:
	MOV EAX, DWORD PTR s ; przenie� pocz�tek bitmapy ("start") do rejestru EAX
	CMP EAX, DWORD PTR e ; por�wnaj koniec bitmapy z jej pocz�tkiem
	JGE EndLoop ; je�li koniec i pocz�tek s� takie same, to zako�cz p�tl�
	;---------------------------
	MOVQ XMM1, QWORD PTR [RSI] ; wpisz 8 warto�ci byte (dzi�ki QWORD) RGB z RSI do XMM1
	MOVAPS XMM2, XMM0 ; przepisz rejestr XMM0 (255) do XMM2, aby zachowa� warto�ci
	PSUBUSB XMM2, XMM1 ; odejmij 8 warto�ci byte (255 - R/G/B)
	VMOVQ QWORD PTR [RSI], XMM2 ; przepisz 8 warto�ci z XMM2 do RSI (zapis nowych warto�ci kolor�w)
	ADD RSI, 8 ; zwi�ksz RSI o 8 (program dzia�a na 8 warto�ciach na raz, wi�c nale�y porusza� si� po bitmapie ze skokiem 8)
	ADD DWORD PTR s, 8 ; zwi�ksz warto�� "start" o 3 (RGB)
	JMP NegativeLoop ; skok do pocz�tku p�tli
EndLoop:
	POP RSI ; przywr�� warto�� stosu
	RET ; powr�t do programu g��wnego
NegativeBitmap ENDP
END

; Autor: Katarzyna Bartoszek
; Temat projektu: Negatyw bitmapy
; Przedmiot: JA
; Rok akademicki: 2019/2020
; Grupa: 1
; Sekcja: 1
; Prowadz¹cy: OA

.DATA
_max dd 255 ; maksymalna wartoœæ koloru
.CODE
NegativeBitmap PROC a: DWORD, b: DWORD, s: DWORD, e: DWORD ; b - wskaŸnik na pocz¹tek bitmapy, s - pocz¹tkowy indeks tablicy, e - koñcowy indeks tablicy
	PUSH RSI ; pocz¹tek stosu, zapis oryginalnej wartoœci RSI
	MOV RSI, R8 ; przenieœ do RSI wskaŸnik do tablicy znajduj¹cy siê w rejestrze R8
	MOV EAX, DWORD PTR s ; przenieœ wartoœæ argumentu "start" (pocz¹tek bitmapy) do EAX
	ADD RSI,  RAX ; przenieœ nag³ówek bêd¹cy pocz¹tkiem bitmapy (o wartoœci 54) do RSI (to, co jest w EAX znajduje siê równie¿ w RAX)
	MOV DWORD PTR e, EBX ; zapisz koniec bitmapy z okna rejestru EBX do parametru "e"
	VMOVD XMM0, [_max] ; wpisz wartoœæ maksymaln¹ koloru (255) do XMM0
	VPBROADCASTB XMM0, XMM0 ; powiel wartoœæ byte rejestru XMM0 na wszystkich pozycjach byte
NegativeLoop:
	MOV EAX, DWORD PTR s ; przenieœ pocz¹tek bitmapy ("start") do rejestru EAX
	CMP EAX, DWORD PTR e ; porównaj koniec bitmapy z jej pocz¹tkiem
	JGE EndLoop ; jeœli koniec i pocz¹tek s¹ takie same, to zakoñcz pêtlê
	;---------------------------
	MOVQ XMM1, QWORD PTR [RSI] ; wpisz 8 wartoœci byte (dziêki QWORD) RGB z RSI do XMM1
	MOVAPS XMM2, XMM0 ; przepisz rejestr XMM0 (255) do XMM2, aby zachowaæ wartoœci
	PSUBUSB XMM2, XMM1 ; odejmij 8 wartoœci byte (255 - R/G/B)
	VMOVQ QWORD PTR [RSI], XMM2 ; przepisz 8 wartoœci z XMM2 do RSI (zapis nowych wartoœci kolorów)
	ADD RSI, 8 ; zwiêksz RSI o 8 (program dzia³a na 8 wartoœciach na raz, wiêc nale¿y poruszaæ siê po bitmapie ze skokiem 8)
	ADD DWORD PTR s, 8 ; zwiêksz wartoœæ "start" o 3 (RGB)
	JMP NegativeLoop ; skok do pocz¹tku pêtli
EndLoop:
	POP RSI ; przywróæ wartoœæ stosu
	RET ; powrót do programu g³ównego
NegativeBitmap ENDP
END

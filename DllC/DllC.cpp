// Autor: Katarzyna Bartoszek
// Temat projektu : Negatyw bitmapy
// Przedmiot: JA
// Rok akademicki : 2019 / 2020
// Grupa: 1
// Sekcja: 1
// Prowadz¹cy: OA

#include "stdafx.h"
#include "DllC.h"


__declspec(dllexport) void NegativeBitmap(unsigned char* bitmap, int start, int end)
{
	for (int i = start; i < end; i += 3)
	{
		bitmap[i] = 255 - bitmap[i];
		bitmap[i + 1] = 255 - bitmap[i + 1];
		bitmap[i + 2] = 255 - bitmap[i + 2];
	}
}

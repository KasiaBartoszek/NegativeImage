using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace NegativeImageExample
{
    public static class DllAsm
    {
        private const string _path = @"C:\Users\Kasia\source\repos\NegativeImageExample\x64\Release\DLLAssembly.dll";

        [DllImport(_path)] public static extern void NegativeBitmap(int start, int end, byte[] bitmap);
    }
}
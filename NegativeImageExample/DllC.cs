using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace NegativeImageExample
{
    public static class DllC
    {
        private const string _path = @"C:\Users\Kasia\source\repos\NegativeImageExample\x64\Release\DllC.dll";

        [DllImport(_path)] public static extern void NegativeBitmap(byte[] bitmap, int start, int end);
    }
}

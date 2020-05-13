// Autor: Katarzyna Bartoszek
// Temat projektu : Negatyw bitmapy
// Przedmiot: JA
// Rok akademicki : 2019 / 2020
// Grupa: 1
// Sekcja: 1
// Prowadzący: OA

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace NegativeImageExample
{
    public partial class Form1 : Form
    {
        private Bitmap _bmp;
        private byte[] _bitmap;
        private Bitmap _bmpOut;
        private const int Header = 54;
        private int _threadAmount = Environment.ProcessorCount;
        private int _start;
        private int _end = 54;

        public Form1()
        {
            InitializeComponent();
            radioButton1.Checked = true;
            numericUpDown1.Value = Environment.ProcessorCount;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            
        }

        public static byte[] ImageToByte(Image image)
        {
            ImageConverter converter = new ImageConverter();
            return (byte[])converter.ConvertTo(image, typeof(byte[]));
        }


        private void button1_Click(object sender, EventArgs e)
        {
            // wczytaj obraz
            OpenFileDialog file = new OpenFileDialog();
            file.ShowDialog();
            _bmp = new Bitmap(file.FileName);

            // załaduj obraz do picturebox1
            if (pictureBox1.Image != null)
            {
                pictureBox1.Image.Dispose();
                pictureBox1.Image = null;
            }
            pictureBox1.Image = new Bitmap(_bmp);
            pictureBox1.Show();

            _bitmap = ImageToByte(_bmp);

            Task[] taskArray = new Task[32];
            List<int> endList = new List<int>();
            List<int> startList = new List<int>();

            // timer
            Stopwatch watch = new Stopwatch();

            // ustawianie końca i początku w zależności od ilości wątków
            for (int i = 1; i <= _threadAmount; i++)
            {
                startList.Add(_end);
                _end = (_bmp.Height * _bmp.Width * 3) / _threadAmount * i + 54;
                endList.Add(_end);
                    
            }

            watch.Start();
            int k = -1;
            if (radioButton1.Checked)
            {
                foreach (int end in endList)
                {
                    k++;
                    taskArray[k] = (Task.Factory.StartNew(() => { DllC.NegativeBitmap(_bitmap, startList[k], end); }));
                    taskArray[k].Wait();
                }
            }
            else
            {
                foreach (int end in endList)
                {
                    k++;
                    taskArray[k] = (Task.Factory.StartNew(() => { DllAsm.NegativeBitmap(startList[k], end, _bitmap); }));
                    taskArray[k].Wait();
                }
            }
            taskArray[k].Wait();

            watch.Stop();
            textBox1.Text = watch.Elapsed.TotalMilliseconds.ToString();
            endList.Clear();
            startList.Clear();

            // załaduj negatyw do picturebox2
            var ss = new System.IO.MemoryStream(_bitmap);
            _bmp = new Bitmap(Bitmap.FromStream(ss));

            pictureBox2.Image = _bmp;
            pictureBox2.Show();
            
            _start = 0;
            _end = 54;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            // zapisz negatyw 
            SaveFileDialog saveDialog = new SaveFileDialog();
            saveDialog.Filter = "Bitmap (*.bmp)|*.bmp";
            saveDialog.ShowDialog();
            File.WriteAllBytes(saveDialog.FileName, _bitmap);
        }

        private void Form1_Load_1(object sender, EventArgs e)
        {

        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
           if(radioButton1.Checked)
                radioButton2.Checked = false;
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton2.Checked)
                radioButton1.Checked = false;
        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        // domyślnie ustaw najlepszą ilość wątków
        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {
            _threadAmount = (int)numericUpDown1.Value;
        }
    }

    
}
using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MagazaOtomasyonu
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=Db_Urunler; user Id=postgres; password=1234");

        /*private void formGetir(Form frm)
        {
            panel1.Controls.Clear();
            //frm.MdiParent = this;
            frm.FormBorderStyle = FormBorderStyle.None;
            //panel1.Controls.Add(frm);
            frm.Show();
        }*/
        private void btnListele_Click(object sender, EventArgs e)
        {
            Urun urunler = new Urun();
            urunler.ShowDialog();
        }

        private void btnSiparis_Click(object sender, EventArgs e)
        {
            Siparis siparisler = new Siparis();
            siparisler.ShowDialog();
        }

        private void btnMusteri_Click(object sender, EventArgs e)
        {
            Musteri musteriler = new Musteri();
            musteriler.ShowDialog();
            
        }

        private void btnYonetici_Click(object sender, EventArgs e)
        {
            Yonetici yoneticiler = new Yonetici();
            yoneticiler.ShowDialog();
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
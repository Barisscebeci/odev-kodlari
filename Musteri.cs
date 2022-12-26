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
    public partial class Musteri : Form
    {
        public Musteri()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=Db_Urunler; user Id=postgres; password=1234");

        private void btnListele_Click(object sender, EventArgs e)
        {
            string sorgu = "SELECT musteri_no,ad,soyad,tel,il_adi,il_kodu FROM musteri inner join adres on musteri.adres_il=adres.il_kodu";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void btnEkle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into musteri (musteri_no,ad,soyad,tel,adres_il) values (@p1,@p2,@p3,@p4,@p5) ", baglanti);

            komut.Parameters.AddWithValue("@p1", int.Parse(txtNo.Text));
            komut.Parameters.AddWithValue("@p2", txtAd.Text);
            komut.Parameters.AddWithValue("@p3", txtSoyad.Text);
            komut.Parameters.AddWithValue("@p4", double.Parse(txtTel.Text));
            komut.Parameters.AddWithValue("@p5", int.Parse(cmbplaka.SelectedValue.ToString()));


            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Müşteri kaydı başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void Musteri_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select * from adres", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            cmbplaka.DisplayMember = "il_adi";
            cmbplaka.ValueMember = "il_kodu";
            cmbplaka.DataSource = dt;
            baglanti.Close();
        }

        private void btnGuncelle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("update musteri set ad=@p2,soyad=@p3,tel=@p4,adres_il=@p5 where musteri_no=@p1 ", baglanti);

            komut.Parameters.AddWithValue("@p1", int.Parse(txtNo.Text));
            komut.Parameters.AddWithValue("@p2", txtAd.Text);
            komut.Parameters.AddWithValue("@p3", txtSoyad.Text);
            komut.Parameters.AddWithValue("@p4", double.Parse(txtTel.Text));
            komut.Parameters.AddWithValue("@p5", int.Parse(cmbplaka.SelectedValue.ToString()));


            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Müşteri güncelleme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnAra_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            string no = txtNo.Text.ToString();
            string sql2 = "SELECT musteri_no,ad,soyad,tel,il_adi,il_kodu FROM musteri inner join adres on musteri.adres_il=adres.il_kodu where musteri_no=('" + no + "')";
            NpgsqlCommand cmd2 = new NpgsqlCommand(sql2, baglanti);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sql2, baglanti);
            DataSet dataSet = new DataSet();
            da.Fill(dataSet);
            dataGridView1.DataSource = dataSet.Tables[0];
            cmd2.ExecuteNonQuery();
            baglanti.Close();

            txtNo.Text = "";
        }

        private void btnSil_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("Delete from musteri where musteri_no=@p1", baglanti);

            komut.Parameters.AddWithValue("@p1", int.Parse(txtNo.Text));

            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Müşteri silme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            baglanti.Close();

        }
    }
}
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
    public partial class Yonetici : Form
    {
        public Yonetici()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=Db_Urunler; user Id=postgres; password=1234");

        private void btnListele_Click(object sender, EventArgs e)
        {
            string sorgu = "select yonetici_id,kategori_ad,ad,soyad from yonetici inner join kategori on yonetici.kategori_id=kategori.kategori_id";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }


        private void Yonetici_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select * from kategori", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            cmbKategori.DisplayMember = "kategori_ad";
            cmbKategori.ValueMember = "kategori_id";
            cmbKategori.DataSource = dt;
            baglanti.Close();
        }

        private void btnEkle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into yonetici (yonetici_id,ad,soyad,kategori_id) values (@p1,@p2,@p3,@p4) ", baglanti);

            komut.Parameters.AddWithValue("@p1", int.Parse(txtId.Text));
            komut.Parameters.AddWithValue("@p2", txtAd.Text);
            komut.Parameters.AddWithValue("@p3", txtSoyad.Text);
            komut.Parameters.AddWithValue("@p4", int.Parse(cmbKategori.SelectedValue.ToString()));


            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Yönetici kaydı başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnGuncelle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("update yonetici set ad=@p2,soyad=@p3,kategori_id=@p4 where yonetici_id=@p1 ", baglanti);

            komut.Parameters.AddWithValue("@p1", int.Parse(txtId.Text));
            komut.Parameters.AddWithValue("@p2", txtAd.Text);
            komut.Parameters.AddWithValue("@p3", txtSoyad.Text);
            komut.Parameters.AddWithValue("@p4", int.Parse(cmbKategori.SelectedValue.ToString()));


            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Yönetici güncelleme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

        }

        private void btnAra_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            int kategori_id = int.Parse(cmbKategori.SelectedValue.ToString());
            string sql2 = "SELECT * FROM yonetici where yonetici.kategori_id=('" + kategori_id + "')";
            NpgsqlCommand cmd2 = new NpgsqlCommand(sql2, baglanti);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sql2, baglanti);
            DataSet dataSet = new DataSet();
            da.Fill(dataSet);
            dataGridView1.DataSource = dataSet.Tables[0];
            cmd2.ExecuteNonQuery();
            baglanti.Close();


        }

        private void btnSil_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("Delete from yonetici where yonetici_id=@p1", baglanti);

            komut.Parameters.AddWithValue("@p1", int.Parse(txtId.Text));

            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Yönetici silme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            baglanti.Close();
        }
    }
}
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
    public partial class Siparis : Form
    {
        public Siparis()
        {
            InitializeComponent();
        }

        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=Db_Urunler; user Id=postgres; password=1234");

        private void btnListele_Click(object sender, EventArgs e)
        {
            string sorgu = "select siparis.siparis_no,ad,soyad,tutar,fatura_no,fatura_adres from siparis inner join fatura on fatura.siparis_no=siparis.siparis_no inner join musteri on musteri.musteri_no=siparis.musteri_no ";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void Siparis_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select * from kargo_firmasi", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            cmbKargo.DisplayMember = "firma_ad";
            cmbKargo.ValueMember = "firma_kodu";
            cmbKargo.DataSource = dt;
            baglanti.Close();

            baglanti.Open();
            NpgsqlDataAdapter daa = new NpgsqlDataAdapter("select * from urun", baglanti);
            DataTable dtt = new DataTable();
            daa.Fill(dtt);
            cmbUrun.DisplayMember = "ad";
            cmbUrun.ValueMember = "urunid";
            cmbUrun.DataSource = dtt;
            baglanti.Close();
        }

        private void btnEkle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into siparis (siparis_no,musteri_no,kargo_firmasi) values (@p1,@p2,@p3)", baglanti);
            NpgsqlCommand komut1 = new NpgsqlCommand("insert into siparis_urun(kayit_no,siparis_no,urun_id,urun_adet) values (@p1,@p2,@p4,@p5)", baglanti);
            komut.Parameters.AddWithValue("@p1", int.Parse(txtSiparisNo.Text));
            komut.Parameters.AddWithValue("@p2", int.Parse(txtMusteriNo.Text));
            komut.Parameters.AddWithValue("@p3", int.Parse(cmbKargo.SelectedValue.ToString()));
            komut1.Parameters.AddWithValue("@p4", int.Parse(cmbUrun.SelectedValue.ToString()));
            komut1.Parameters.AddWithValue("@p5", int.Parse(txtAdet.Text));
            komut1.Parameters.AddWithValue("@p1", int.Parse(txtSiparisNo.Text));
            komut1.Parameters.AddWithValue("@p2", int.Parse(txtSiparisNo.Text));

            komut.ExecuteNonQuery();
            komut1.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Sipariş kaydı başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnGuncelle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("update siparis set musteri_no=@p2,kargo_firmasi=@p3 where siparis_no=@p1", baglanti);
            NpgsqlCommand komut1 = new NpgsqlCommand("update siparis_urun set siparis_no=@p1,urun_id=@p4,urun_adet=@p5 where kayit_no=@p1", baglanti);
            komut.Parameters.AddWithValue("@p1", int.Parse(txtSiparisNo.Text));
            komut.Parameters.AddWithValue("@p2", int.Parse(txtMusteriNo.Text));
            komut.Parameters.AddWithValue("@p3", int.Parse(cmbKargo.SelectedValue.ToString()));
            komut1.Parameters.AddWithValue("@p4", int.Parse(cmbUrun.SelectedValue.ToString()));
            komut1.Parameters.AddWithValue("@p5", int.Parse(txtAdet.Text));
            komut1.Parameters.AddWithValue("@p1", int.Parse(txtSiparisNo.Text));
            komut1.Parameters.AddWithValue("@p2", int.Parse(txtMusteriNo.Text));

            komut.ExecuteNonQuery();
            komut1.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Sipariş güncelleme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnAra_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            string no = txtSiparisNo.Text.ToString();
            string sql2 = "SELECT siparis_no,musteri.musteri_no,musteri.ad,musteri.soyad,tutar,kargo_firmasi.firma_ad from siparis inner join kargo_firmasi on kargo_firmasi.firma_kodu=siparis.kargo_firmasi inner join musteri on musteri.musteri_no=siparis.musteri_no where siparis_no=('" + no + "')";
            NpgsqlCommand cmd2 = new NpgsqlCommand(sql2, baglanti);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sql2, baglanti);
            DataSet dataSet = new DataSet();
            da.Fill(dataSet);
            dataGridView1.DataSource = dataSet.Tables[0];
            cmd2.ExecuteNonQuery();
            baglanti.Close();

            txtSiparisNo.Text = "";
        }

        private void btnSil_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("Delete from siparis where siparis_no=@p1", baglanti);
            NpgsqlCommand komut1 = new NpgsqlCommand("Delete from siparis_urun where siparis_no=@p1", baglanti);
            NpgsqlCommand komut2 = new NpgsqlCommand("Delete from fatura where siparis_no=@p1", baglanti);


            komut.Parameters.AddWithValue("@p1", int.Parse(txtSiparisNo.Text));
            komut1.Parameters.AddWithValue("@p1", int.Parse(txtSiparisNo.Text));
            komut2.Parameters.AddWithValue("@p1", int.Parse(txtSiparisNo.Text));

            komut2.ExecuteNonQuery();
            komut1.ExecuteNonQuery();
            komut.ExecuteNonQuery();


            baglanti.Close();
            MessageBox.Show("Sipariş silme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            baglanti.Close();
            txtSiparisNo.Text = " ";

        }
    }
}
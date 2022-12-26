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
    public partial class Urun : Form
    {
        public Urun()
        {
            InitializeComponent();
        }


        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port=5432; Database=Db_Urunler; user Id=postgres; password=1234");

        private void btnListele_Click(object sender, EventArgs e)
        {
            //her ürünün alış fiyatını ve birim kazancını da yazdırır.
            string sorgu = "SELECT urun.urunid, ad, fiyat,alis_fiyati,karorani_bul(urun.urunid,alis_fiyati,fiyat)  FROM urun INNER JOIN birim_kazanc ON urun.urunid = birim_kazanc.urunid";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void urun_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("select * from kategori", baglanti);
            DataTable dt = new DataTable();
            da.Fill(dt);
            cmbKategori.DisplayMember = "kategori_ad";
            cmbKategori.ValueMember = "kategori_id";
            cmbKategori.DataSource = dt;
            baglanti.Close();

            baglanti.Open();
            NpgsqlDataAdapter daa = new NpgsqlDataAdapter("select * from marka", baglanti);
            DataTable dtt = new DataTable();
            daa.Fill(dtt);
            cmbMarka.DisplayMember = "ad";
            cmbMarka.ValueMember = "markakod";
            cmbMarka.DataSource = dtt;
            baglanti.Close();

            baglanti.Open();
            NpgsqlDataAdapter daaa = new NpgsqlDataAdapter("select * from tedarikci", baglanti);
            DataTable dttt = new DataTable();
            daaa.Fill(dttt);
            cmbTedarikci.DisplayMember = "ad";
            cmbTedarikci.ValueMember = "tedarikno";
            cmbTedarikci.DataSource = dttt;
            baglanti.Close();



        }

        private void btnEkle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("insert into urun (urunid,ad,fiyat,kategori,marka,tedarikci) values (@p1,@p2,@p3,@p4,@p5,@p6) ", baglanti);
            NpgsqlCommand komut1 = new NpgsqlCommand("insert into birim_kazanc(urunid, alis_fiyati) values(@p1, @p7)", baglanti);

            NpgsqlCommand komut2 = new NpgsqlCommand("insert into stok_bilgisi(urun_id, stok_adet) values(@p1, @p8)", baglanti);
            komut.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut.Parameters.AddWithValue("@p2", txtAd.Text);
            komut.Parameters.AddWithValue("@p3", double.Parse(txtFiyat.Text));
            komut.Parameters.AddWithValue("@p4", int.Parse(cmbKategori.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p5", int.Parse(cmbMarka.SelectedValue.ToString()));
            komut.Parameters.AddWithValue("@p6", int.Parse(cmbTedarikci.SelectedValue.ToString()));
            komut1.Parameters.AddWithValue("@p7", double.Parse(txtAlisfiyat.Text));
            komut1.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut2.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut2.Parameters.AddWithValue("@p8", int.Parse(txtStok.Text));

            komut.ExecuteNonQuery();
            komut2.ExecuteNonQuery();
            komut1.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Ürün kaydı başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }


        private void btnGuncelle_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut3 = new NpgsqlCommand("update urun set ad=@p2,fiyat=@p3,kategori=@p4,marka=@p5,tedarikci=@p6 where urunid=@p1", baglanti);
            NpgsqlCommand komut4 = new NpgsqlCommand("update birim_kazanc set alis_fiyati=@p7 where urunid=@p1", baglanti);
            NpgsqlCommand komut5 = new NpgsqlCommand("update stok_bilgisi set stok_adet=@p8 where urun_id=@p1", baglanti);

            komut3.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut3.Parameters.AddWithValue("@p2", txtAd.Text);
            komut3.Parameters.AddWithValue("@p3", double.Parse(txtFiyat.Text));
            komut3.Parameters.AddWithValue("@p4", int.Parse(cmbKategori.SelectedValue.ToString()));
            komut3.Parameters.AddWithValue("@p5", int.Parse(cmbMarka.SelectedValue.ToString()));
            komut3.Parameters.AddWithValue("@p6", int.Parse(cmbTedarikci.SelectedValue.ToString()));
            komut4.Parameters.AddWithValue("@p7", double.Parse(txtAlisfiyat.Text));
            komut4.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut5.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut5.Parameters.AddWithValue("@p8", int.Parse(txtid.Text));

            komut5.ExecuteNonQuery();
            komut3.ExecuteNonQuery();
            komut4.ExecuteNonQuery();
            baglanti.Close();
            MessageBox.Show("Ürün güncelleme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnAra_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            string id = txtid.Text.ToString();
            string sql2 = "SELECT urun.urunid, ad, fiyat,alis_fiyati,karorani_bul(urun.urunid,alis_fiyati,fiyat)  FROM urun INNER JOIN birim_kazanc ON urun.urunid = birim_kazanc.urunid where urun.urunid=('" + id + "')";
            NpgsqlCommand cmd2 = new NpgsqlCommand(sql2, baglanti);
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sql2, baglanti);
            DataSet dataSet = new DataSet();
            da.Fill(dataSet);
            dataGridView1.DataSource = dataSet.Tables[0];
            cmd2.ExecuteNonQuery();
            baglanti.Close();

            txtid.Text = "";
        }

        private void btnSil_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut = new NpgsqlCommand("Delete from urun where urunid=@p1", baglanti);

            NpgsqlCommand komut3 = new NpgsqlCommand("Delete from stok_azalanlar where urun_id=@p1", baglanti);
            NpgsqlCommand komut1 = new NpgsqlCommand("Delete from birim_kazanc where urunid=@p1", baglanti);
            NpgsqlCommand komut2 = new NpgsqlCommand("Delete from stok_bilgisi where urun_id=@p1", baglanti);

            komut1.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut2.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));
            komut3.Parameters.AddWithValue("@p1", int.Parse(txtid.Text));

            komut3.ExecuteNonQuery();
            komut2.ExecuteNonQuery();
            komut1.ExecuteNonQuery();
            komut.ExecuteNonQuery();

            baglanti.Close();
            MessageBox.Show("Ürün silme başarılı bir şekilde gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            baglanti.Close();

        }

        private void btnStok_Click(object sender, EventArgs e)
        {
            string sorgu = "SELECT *from stok_bilgisi";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void txtid_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
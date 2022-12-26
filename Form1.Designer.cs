namespace MagazaOtomasyonu
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnListele = new System.Windows.Forms.Button();
            this.btnSiparis = new System.Windows.Forms.Button();
            this.btnMusteri = new System.Windows.Forms.Button();
            this.btnYonetici = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnListele
            // 
            this.btnListele.BackColor = System.Drawing.SystemColors.Info;
            this.btnListele.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.btnListele.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(64)))), ((int)(((byte)(64)))));
            this.btnListele.Location = new System.Drawing.Point(60, 94);
            this.btnListele.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            this.btnListele.Name = "btnListele";
            this.btnListele.Size = new System.Drawing.Size(165, 53);
            this.btnListele.TabIndex = 0;
            this.btnListele.Text = "Ürün İşlemleri";
            this.btnListele.UseVisualStyleBackColor = false;
            this.btnListele.Click += new System.EventHandler(this.btnListele_Click);
            // 
            // btnSiparis
            // 
            this.btnSiparis.BackColor = System.Drawing.SystemColors.Info;
            this.btnSiparis.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.btnSiparis.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(64)))), ((int)(((byte)(64)))));
            this.btnSiparis.Location = new System.Drawing.Point(60, 209);
            this.btnSiparis.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            this.btnSiparis.Name = "btnSiparis";
            this.btnSiparis.Size = new System.Drawing.Size(159, 53);
            this.btnSiparis.TabIndex = 2;
            this.btnSiparis.Text = "Sipariş İşlemleri";
            this.btnSiparis.UseVisualStyleBackColor = false;
            this.btnSiparis.Click += new System.EventHandler(this.btnSiparis_Click);
            // 
            // btnMusteri
            // 
            this.btnMusteri.BackColor = System.Drawing.SystemColors.Info;
            this.btnMusteri.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.btnMusteri.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(64)))), ((int)(((byte)(64)))));
            this.btnMusteri.Location = new System.Drawing.Point(299, 94);
            this.btnMusteri.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            this.btnMusteri.Name = "btnMusteri";
            this.btnMusteri.Size = new System.Drawing.Size(158, 53);
            this.btnMusteri.TabIndex = 3;
            this.btnMusteri.Text = "Müşteri İşlemleri";
            this.btnMusteri.UseVisualStyleBackColor = false;
            this.btnMusteri.Click += new System.EventHandler(this.btnMusteri_Click);
            // 
            // btnYonetici
            // 
            this.btnYonetici.BackColor = System.Drawing.SystemColors.Info;
            this.btnYonetici.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.btnYonetici.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(64)))), ((int)(((byte)(64)))));
            this.btnYonetici.Location = new System.Drawing.Point(299, 209);
            this.btnYonetici.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            this.btnYonetici.Name = "btnYonetici";
            this.btnYonetici.Size = new System.Drawing.Size(159, 53);
            this.btnYonetici.TabIndex = 4;
            this.btnYonetici.Text = "Yönetici İşlemleri";
            this.btnYonetici.UseVisualStyleBackColor = false;
            this.btnYonetici.Click += new System.EventHandler(this.btnYonetici_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoValidate = System.Windows.Forms.AutoValidate.EnablePreventFocusChange;
            this.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.ClientSize = new System.Drawing.Size(531, 373);
            this.Controls.Add(this.btnYonetici);
            this.Controls.Add(this.btnMusteri);
            this.Controls.Add(this.btnSiparis);
            this.Controls.Add(this.btnListele);
            this.ForeColor = System.Drawing.SystemColors.InactiveCaption;
            this.Margin = new System.Windows.Forms.Padding(4, 3, 4, 3);
            this.Name = "Form1";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Mağaza Kontrol Sistemi";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnListele;
        private System.Windows.Forms.Button btnSiparis;
        private System.Windows.Forms.Button btnMusteri;
        private System.Windows.Forms.Button btnYonetici;
    }
}

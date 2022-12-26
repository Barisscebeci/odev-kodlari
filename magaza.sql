--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.5

-- Started on 2022-12-26 16:14:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 225 (class 1255 OID 17290)
-- Name: fatura_olusturma(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fatura_olusturma() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT into fatura VALUES (new.siparis_no,' ',new.siparis_no);
RETURN NEW;
END;

$$;


ALTER FUNCTION public.fatura_olusturma() OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 17289)
-- Name: karorani_bul(integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.karorani_bul(urun_id integer, alisfiyat double precision, fiyat double precision) RETURNS TABLE(birim_kazanc double precision)
    LANGUAGE plpgsql
    AS $$
declare vergiorani float;
kategoriid int;
BEGIN
    
	kategoriid:=(SELECT urun.kategori FROM "urun" where "urun_id" = urunid );
	vergiorani:=(select* from vergioranibul(kategoriid));
	update birim_kazanc set birimkazanc=(fiyat-(alisfiyat+vergiorani*fiyat));
	return query	
	SELECT birimkazanc FROM birim_kazanc
                 WHERE "urun_id" = urunid;			 
			 
END;
$$;


ALTER FUNCTION public.karorani_bul(urun_id integer, alisfiyat double precision, fiyat double precision) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 17291)
-- Name: kdvli(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kdvli(fiyat double precision, kdvorani double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
declare 
kdvlifiyat float;
begin
kdvlifiyat:=fiyat*kdvorani+fiyat;
return kdvlifiyat;
end;
$$;


ALTER FUNCTION public.kdvli(fiyat double precision, kdvorani double precision) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 17293)
-- Name: stok_azalan(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stok_azalan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN
if new.stok_adet<50 then
INSERT into stok_azalanlar VALUES (new.urun_id,new.stok_adet,new.stok_durumu);
end if;
RETURN NEW;
END;

$$;


ALTER FUNCTION public.stok_azalan() OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 17294)
-- Name: stok_sayac(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stok_sayac() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
 update stok_bilgisi set stok_adet = (stok_adet-new.urun_adet);
return new;
end;
$$;


ALTER FUNCTION public.stok_sayac() OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 17295)
-- Name: stokazalanurunler(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stokazalanurunler() RETURNS TABLE(urunid integer, stokadet integer)
    LANGUAGE plpgsql
    AS $$
begin
return Query
SELECT urun_id,stok_adet FROM public.stok_bilgisi where stok_adet<50
ORDER BY urun_id ASC;
end;
$$;


ALTER FUNCTION public.stokazalanurunler() OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 17296)
-- Name: stokdurumu(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stokdurumu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

IF NEW.stok_adet >=50 THEN
NEW.stok_durumu = 'Stok yeterli';
else 
NEW.stok_durumu = 'Tedarik edilmeli';
end if;

return new;

end;
$$;


ALTER FUNCTION public.stokdurumu() OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 17297)
-- Name: tutar_hesaplama(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tutar_hesaplama() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare urunfiyat float;
		fiyati float;
		sayac int:=0;
		satirsayisi int;
BEGIN
--fiyat=fiyat from urun inner join siparis_urun on urun.urunid= siparis_urun.urun_id;
--satirsayisi:=(SELECT COUNT(*) FROM siparis);
--while sayac<=satirsayisi
--loop
fiyati:=(SELECT urun.fiyat FROM "urun"  where urun.urunid=new.urun_id);
urunfiyat:=fiyati* new.urun_adet;
--end loop;
update siparis set tutar = urunfiyat where siparis_no=new.siparis_no ;

RETURN NEW;

END;
$$;


ALTER FUNCTION public.tutar_hesaplama() OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 17292)
-- Name: vergioranibul(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.vergioranibul(kategoriid integer) RETURNS TABLE(kdvorani double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
	SELECT kdv_orani FROM kdv_degeri
                 WHERE "kategoriid" = kategori_id;
				 
				 
END;
$$;


ALTER FUNCTION public.vergioranibul(kategoriid integer) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 17298)
-- Name: yoneticiara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.yoneticiara(kategoriid integer) RETURNS TABLE(yoneticiid integer, adi character varying, soyadi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
	SELECT yonetici_id, ad,soyad FROM yonetici
                 WHERE "kategoriid" = kategori_id;
END;
$$;


ALTER FUNCTION public.yoneticiara(kategoriid integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 17299)
-- Name: adres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adres (
    il_kodu integer NOT NULL,
    il_adi character varying(20)
);


ALTER TABLE public.adres OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 17302)
-- Name: birim_kazanc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.birim_kazanc (
    urunid integer NOT NULL,
    alis_fiyati integer NOT NULL,
    birimkazanc double precision
);


ALTER TABLE public.birim_kazanc OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 17305)
-- Name: fatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fatura (
    fatura_no integer NOT NULL,
    fatura_adres text,
    siparis_no integer
);


ALTER TABLE public.fatura OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 17310)
-- Name: kargo_firmasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kargo_firmasi (
    firma_kodu integer NOT NULL,
    firma_ad character varying(20)
);


ALTER TABLE public.kargo_firmasi OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 17313)
-- Name: kategori; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kategori (
    kategori_id integer NOT NULL,
    kategori_ad character varying
);


ALTER TABLE public.kategori OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17318)
-- Name: kdv_degeri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kdv_degeri (
    kdv_orani double precision NOT NULL,
    kategori_id integer NOT NULL
);


ALTER TABLE public.kdv_degeri OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 17321)
-- Name: marka; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marka (
    markakod integer NOT NULL,
    ad character varying
);


ALTER TABLE public.marka OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17326)
-- Name: musteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.musteri (
    musteri_no integer NOT NULL,
    ad character varying(20),
    soyad character varying(20),
    tel double precision,
    adres_il integer
);


ALTER TABLE public.musteri OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17329)
-- Name: siparis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siparis (
    siparis_no integer NOT NULL,
    musteri_no integer,
    tutar integer,
    kargo_firmasi integer
);


ALTER TABLE public.siparis OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17332)
-- Name: siparis_urun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siparis_urun (
    kayit_no integer NOT NULL,
    siparis_no integer,
    urun_id integer,
    urun_adet integer
);


ALTER TABLE public.siparis_urun OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17335)
-- Name: urun; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.urun (
    urunid integer NOT NULL,
    ad character varying(20),
    fiyat integer,
    kategori integer,
    marka integer,
    tedarikci integer
);


ALTER TABLE public.urun OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17338)
-- Name: siparisbilgisi; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.siparisbilgisi AS
 SELECT urun.urunid,
    urun.fiyat,
    siparis_urun.urun_id,
    siparis_urun.urun_adet,
    siparis_urun.siparis_no
   FROM (public.urun
     JOIN public.siparis_urun ON ((urun.urunid = siparis_urun.urun_id)));


ALTER TABLE public.siparisbilgisi OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17342)
-- Name: stok_azalanlar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stok_azalanlar (
    urun_id integer NOT NULL,
    stok_adet integer,
    stok_durumu character varying(40)
);


ALTER TABLE public.stok_azalanlar OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17345)
-- Name: stok_bilgisi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stok_bilgisi (
    urun_id integer NOT NULL,
    stok_adet integer,
    stok_durumu character varying(40)
);


ALTER TABLE public.stok_bilgisi OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17348)
-- Name: tedarikci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tedarikci (
    tedarikno integer NOT NULL,
    ad character varying(20),
    tel integer
);


ALTER TABLE public.tedarikci OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17351)
-- Name: yonetici; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yonetici (
    yonetici_id integer NOT NULL,
    ad character varying,
    soyad character varying,
    kategori_id integer
);


ALTER TABLE public.yonetici OWNER TO postgres;

--
-- TOC entry 3437 (class 0 OID 17299)
-- Dependencies: 209
-- Data for Name: adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adres (il_kodu, il_adi) FROM stdin;
34	İstanbul
54	Sakarya
21	Diyarbakır
1	Adana
81	Düzce
\.


--
-- TOC entry 3438 (class 0 OID 17302)
-- Dependencies: 210
-- Data for Name: birim_kazanc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.birim_kazanc (urunid, alis_fiyati, birimkazanc) FROM stdin;
8	86	110
1	107	110
2	527	110
3	507	110
5	252	110
7	555	110
4	300	110
\.


--
-- TOC entry 3439 (class 0 OID 17305)
-- Dependencies: 211
-- Data for Name: fatura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fatura (fatura_no, fatura_adres, siparis_no) FROM stdin;
1	istanbul/beylikdüzü	1
3	Bursa	3
4	 	4
5	 	5
6	 	6
7	 	7
8	 	8
9	 	9
10	 	10
15	 	15
2	 	2
55	 	55
\.


--
-- TOC entry 3440 (class 0 OID 17310)
-- Dependencies: 212
-- Data for Name: kargo_firmasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kargo_firmasi (firma_kodu, firma_ad) FROM stdin;
1	Aras Kargo\n
2	PTT
3	Yurtiçi Kargo
\.


--
-- TOC entry 3441 (class 0 OID 17313)
-- Dependencies: 213
-- Data for Name: kategori; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kategori (kategori_id, kategori_ad) FROM stdin;
3	Ayakkabı
1	DIŞ GİYİM
2	ÜST GİYİM
4	ALT GİYİM
5	AKSESUAR
\.


--
-- TOC entry 3442 (class 0 OID 17318)
-- Dependencies: 214
-- Data for Name: kdv_degeri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kdv_degeri (kdv_orani, kategori_id) FROM stdin;
0.1	1
0.15	2
0.3	3
0.5	4
0.2	5
\.


--
-- TOC entry 3443 (class 0 OID 17321)
-- Dependencies: 215
-- Data for Name: marka; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marka (markakod, ad) FROM stdin;
1	ZARA
2	MANGO
3	LC-WAİKİKİ
4	KOTON
5	HM
6	NİKE
7	ADİDAS
8	LOUİS VİTTON
\.


--
-- TOC entry 3444 (class 0 OID 17326)
-- Dependencies: 216
-- Data for Name: musteri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.musteri (musteri_no, ad, soyad, tel, adres_il) FROM stdin;
1	Ahmet Dede	Işık	5345545454	34
2	Selim	Temizel	5452422413	1
3	Aysu	Çelik	56975131344	21
\.


--
-- TOC entry 3445 (class 0 OID 17329)
-- Dependencies: 217
-- Data for Name: siparis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.siparis (siparis_no, musteri_no, tutar, kargo_firmasi) FROM stdin;
15	2	758	1
4	2	1521	1
5	2	1521	3
6	1	1521	3
7	3	1521	2
8	3	1521	1
9	3	1521	1
10	3	1521	1
1	1	1521	1
3	2	1521	1
2	2	\N	1
55	2	\N	1
\.


--
-- TOC entry 3446 (class 0 OID 17332)
-- Dependencies: 218
-- Data for Name: siparis_urun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.siparis_urun (kayit_no, siparis_no, urun_id, urun_adet) FROM stdin;
4	4	1	9
5	5	1	9
1	1	1	9
3	3	1	9
6	6	1	9
7	7	1	9
8	8	1	9
9	9	1	9
10	10	1	9
15	15	2	1
\.


--
-- TOC entry 3448 (class 0 OID 17342)
-- Dependencies: 221
-- Data for Name: stok_azalanlar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stok_azalanlar (urun_id, stok_adet, stok_durumu) FROM stdin;
1	11	Tedarik edilmeli
2	21	Tedarik edilmeli
7	47	Tedarik edilmeli
4	4	Tedarik edilmeli
8	8	Tedarik edilmeli
\.


--
-- TOC entry 3449 (class 0 OID 17345)
-- Dependencies: 222
-- Data for Name: stok_bilgisi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stok_bilgisi (urun_id, stok_adet, stok_durumu) FROM stdin;
3	65	Stok yeterli
8	8	Tedarik edilmeli
10	85	Stok yeterli
1	11	Tedarik edilmeli
2	21	Tedarik edilmeli
7	47	Tedarik edilmeli
5	422	Stok yeterli
4	4	Tedarik edilmeli
\.


--
-- TOC entry 3450 (class 0 OID 17348)
-- Dependencies: 223
-- Data for Name: tedarikci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tedarikci (tedarikno, ad, tel) FROM stdin;
1	US Marketing	212360
2	Barış Dağıtım	50513553
3	İ.T Sales	213653
\.


--
-- TOC entry 3447 (class 0 OID 17335)
-- Dependencies: 219
-- Data for Name: urun; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.urun (urunid, ad, fiyat, kategori, marka, tedarikci) FROM stdin;
10	kjkk	555	1	1	1
2	Kazak	758	2	3	1
6	Jean Pantalon	95	4	8	1
3	Kaban	750	1	4	3
5	Mont	50	1	7	3
7	Takı	750	5	3	1
1	Pantolon	169	4	5	2
4	Spoar AYAKKABI	600	3	6	1
8	Şapka	444	5	5	2
\.


--
-- TOC entry 3451 (class 0 OID 17351)
-- Dependencies: 224
-- Data for Name: yonetici; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.yonetici (yonetici_id, ad, soyad, kategori_id) FROM stdin;
2	Mauro	İcardi	3
5	Fernando	Muslera	2
4	Sacha	Boey	5
3	Milot	Rashica	3
\.


--
-- TOC entry 3234 (class 2606 OID 17357)
-- Name: adres adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (il_kodu);


--
-- TOC entry 3236 (class 2606 OID 17359)
-- Name: birim_kazanc birim_kazanc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.birim_kazanc
    ADD CONSTRAINT birim_kazanc_pkey PRIMARY KEY (urunid);


--
-- TOC entry 3239 (class 2606 OID 17361)
-- Name: fatura fatura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatura
    ADD CONSTRAINT fatura_pkey PRIMARY KEY (fatura_no);


--
-- TOC entry 3242 (class 2606 OID 17363)
-- Name: kargo_firmasi kargo_firmasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kargo_firmasi
    ADD CONSTRAINT kargo_firmasi_pkey PRIMARY KEY (firma_kodu);


--
-- TOC entry 3247 (class 2606 OID 17365)
-- Name: kdv_degeri kategor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kdv_degeri
    ADD CONSTRAINT kategor_pkey PRIMARY KEY (kategori_id) INCLUDE (kategori_id);


--
-- TOC entry 3244 (class 2606 OID 17367)
-- Name: kategori kategori_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY (kategori_id);


--
-- TOC entry 3249 (class 2606 OID 17369)
-- Name: marka marka_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marka
    ADD CONSTRAINT marka_pkey PRIMARY KEY (markakod);


--
-- TOC entry 3252 (class 2606 OID 17371)
-- Name: musteri musteri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_pkey PRIMARY KEY (musteri_no);


--
-- TOC entry 3256 (class 2606 OID 17373)
-- Name: siparis siparis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_pkey PRIMARY KEY (siparis_no);


--
-- TOC entry 3260 (class 2606 OID 17375)
-- Name: siparis_urun siparis_urun_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT siparis_urun_pkey PRIMARY KEY (kayit_no);


--
-- TOC entry 3267 (class 2606 OID 17377)
-- Name: stok_azalanlar stok_azalanlar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_azalanlar
    ADD CONSTRAINT stok_azalanlar_pkey PRIMARY KEY (urun_id);


--
-- TOC entry 3269 (class 2606 OID 17379)
-- Name: stok_bilgisi stok_bilgisi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_bilgisi
    ADD CONSTRAINT stok_bilgisi_pkey PRIMARY KEY (urun_id);


--
-- TOC entry 3271 (class 2606 OID 17381)
-- Name: tedarikci tedarikci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tedarikci
    ADD CONSTRAINT tedarikci_pkey PRIMARY KEY (tedarikno);


--
-- TOC entry 3265 (class 2606 OID 17383)
-- Name: urun urun_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urun
    ADD CONSTRAINT urun_pkey PRIMARY KEY (urunid);


--
-- TOC entry 3274 (class 2606 OID 17385)
-- Name: yonetici yonetici_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici
    ADD CONSTRAINT yonetici_pkey PRIMARY KEY (yonetici_id);


--
-- TOC entry 3250 (class 1259 OID 17386)
-- Name: fki_adres_il_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_adres_il_fkey ON public.musteri USING btree (adres_il);


--
-- TOC entry 3253 (class 1259 OID 17387)
-- Name: fki_kargo_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_kargo_fkey ON public.siparis USING btree (kargo_firmasi);


--
-- TOC entry 3261 (class 1259 OID 17388)
-- Name: fki_kategor_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_kategor_fkey ON public.urun USING btree (kategori);


--
-- TOC entry 3245 (class 1259 OID 17389)
-- Name: fki_kategori_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_kategori_fkey ON public.kdv_degeri USING btree (kategori_id);


--
-- TOC entry 3272 (class 1259 OID 17390)
-- Name: fki_kategorii_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_kategorii_fkey ON public.yonetici USING btree (kategori_id);


--
-- TOC entry 3262 (class 1259 OID 17391)
-- Name: fki_marka_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_marka_fkey ON public.urun USING btree (marka);


--
-- TOC entry 3254 (class 1259 OID 17392)
-- Name: fki_musteri_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_musteri_fkey ON public.siparis USING btree (musteri_no);


--
-- TOC entry 3257 (class 1259 OID 17393)
-- Name: fki_siparisno_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_siparisno_fkey ON public.siparis_urun USING btree (siparis_no);


--
-- TOC entry 3240 (class 1259 OID 17394)
-- Name: fki_siparisno_foreign; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_siparisno_foreign ON public.fatura USING btree (siparis_no);


--
-- TOC entry 3263 (class 1259 OID 17395)
-- Name: fki_tedarikci_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_tedarikci_fkey ON public.urun USING btree (tedarikci);


--
-- TOC entry 3258 (class 1259 OID 17396)
-- Name: fki_urun_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_urun_fkey ON public.siparis_urun USING btree (urun_id);


--
-- TOC entry 3237 (class 1259 OID 17397)
-- Name: fki_urunid_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_urunid_fkey ON public.birim_kazanc USING btree (urunid);


--
-- TOC entry 3291 (class 2620 OID 17398)
-- Name: siparis fatura_olustur; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER fatura_olustur AFTER INSERT ON public.siparis FOR EACH ROW EXECUTE FUNCTION public.fatura_olusturma();


--
-- TOC entry 3292 (class 2620 OID 17399)
-- Name: siparis_urun stok_eksilt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stok_eksilt AFTER INSERT OR UPDATE ON public.siparis_urun FOR EACH ROW EXECUTE FUNCTION public.stok_sayac();


--
-- TOC entry 3296 (class 2620 OID 17400)
-- Name: stok_bilgisi tabloya_ekleme; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tabloya_ekleme AFTER INSERT OR UPDATE ON public.stok_bilgisi FOR EACH ROW EXECUTE FUNCTION public.stok_azalan();


--
-- TOC entry 3293 (class 2620 OID 17401)
-- Name: siparis_urun tutar_hesapla; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tutar_hesapla BEFORE INSERT OR UPDATE ON public.siparis_urun FOR EACH ROW EXECUTE FUNCTION public.tutar_hesaplama();


--
-- TOC entry 3294 (class 2620 OID 17402)
-- Name: siparisbilgisi tutar_hesapla; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tutar_hesapla INSTEAD OF INSERT OR UPDATE ON public.siparisbilgisi FOR EACH ROW EXECUTE FUNCTION public.tutar_hesaplama();


--
-- TOC entry 3295 (class 2620 OID 17403)
-- Name: stok_bilgisi updte_stok; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updte_stok BEFORE INSERT OR UPDATE ON public.stok_bilgisi FOR EACH ROW EXECUTE FUNCTION public.stokdurumu();


--
-- TOC entry 3279 (class 2606 OID 17404)
-- Name: musteri adres_il_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT adres_il_fkey FOREIGN KEY (adres_il) REFERENCES public.adres(il_kodu) NOT VALID;


--
-- TOC entry 3280 (class 2606 OID 17409)
-- Name: siparis kargo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT kargo_fkey FOREIGN KEY (kargo_firmasi) REFERENCES public.kargo_firmasi(firma_kodu) NOT VALID;


--
-- TOC entry 3285 (class 2606 OID 17414)
-- Name: urun kategor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urun
    ADD CONSTRAINT kategor_fkey FOREIGN KEY (kategori) REFERENCES public.kategori(kategori_id) NOT VALID;


--
-- TOC entry 3278 (class 2606 OID 17419)
-- Name: kdv_degeri kategori_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kdv_degeri
    ADD CONSTRAINT kategori_fkey FOREIGN KEY (kategori_id) REFERENCES public.kategori(kategori_id) NOT VALID;


--
-- TOC entry 3290 (class 2606 OID 17424)
-- Name: yonetici kategorii_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetici
    ADD CONSTRAINT kategorii_fkey FOREIGN KEY (kategori_id) REFERENCES public.kategori(kategori_id) NOT VALID;


--
-- TOC entry 3286 (class 2606 OID 17429)
-- Name: urun marka_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urun
    ADD CONSTRAINT marka_fkey FOREIGN KEY (marka) REFERENCES public.marka(markakod) NOT VALID;


--
-- TOC entry 3281 (class 2606 OID 17434)
-- Name: siparis musteri_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT musteri_fkey FOREIGN KEY (musteri_no) REFERENCES public.musteri(musteri_no) NOT VALID;


--
-- TOC entry 3282 (class 2606 OID 17439)
-- Name: siparis_urun siparisno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT siparisno_fkey FOREIGN KEY (siparis_no) REFERENCES public.siparis(siparis_no) NOT VALID;


--
-- TOC entry 3276 (class 2606 OID 17444)
-- Name: fatura siparisno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatura
    ADD CONSTRAINT siparisno_fkey FOREIGN KEY (siparis_no) REFERENCES public.siparis(siparis_no) NOT VALID;


--
-- TOC entry 3277 (class 2606 OID 17449)
-- Name: fatura siparisno_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fatura
    ADD CONSTRAINT siparisno_foreign FOREIGN KEY (siparis_no) REFERENCES public.siparis(siparis_no) NOT VALID;


--
-- TOC entry 3288 (class 2606 OID 17454)
-- Name: stok_azalanlar stok_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_azalanlar
    ADD CONSTRAINT stok_fkey FOREIGN KEY (urun_id) REFERENCES public.stok_bilgisi(urun_id) NOT VALID;


--
-- TOC entry 3287 (class 2606 OID 17459)
-- Name: urun tedarikci_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urun
    ADD CONSTRAINT tedarikci_fkey FOREIGN KEY (tedarikci) REFERENCES public.tedarikci(tedarikno) NOT VALID;


--
-- TOC entry 3283 (class 2606 OID 17464)
-- Name: siparis_urun urun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT urun_fkey FOREIGN KEY (urun_id) REFERENCES public.urun(urunid) NOT VALID;


--
-- TOC entry 3275 (class 2606 OID 17469)
-- Name: birim_kazanc urunid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.birim_kazanc
    ADD CONSTRAINT urunid_fkey FOREIGN KEY (urunid) REFERENCES public.urun(urunid) NOT VALID;


--
-- TOC entry 3289 (class 2606 OID 17474)
-- Name: stok_bilgisi urunid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_bilgisi
    ADD CONSTRAINT urunid_fkey FOREIGN KEY (urun_id) REFERENCES public.urun(urunid) NOT VALID;


--
-- TOC entry 3284 (class 2606 OID 17479)
-- Name: siparis_urun urunid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis_urun
    ADD CONSTRAINT urunid_fkey FOREIGN KEY (urun_id) REFERENCES public.urun(urunid) NOT VALID;


-- Completed on 2022-12-26 16:14:09

--
-- PostgreSQL database dump complete
--


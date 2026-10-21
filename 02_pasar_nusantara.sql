-- =====================================================================
-- Praktikum Basis Data - Pertemuan 6
-- Database : pasar_nusantara  (marketplace UMKM, skema 3NF dari Pertemuan 5)
-- Cara pakai: buat database dulu -> CREATE DATABASE pasar_nusantara;
--             lalu jalankan seluruh skrip ini di Query Tool (F5)
--             atau dari psql:  \i 02_pasar_nusantara.sql
-- =====================================================================
DROP TABLE IF EXISTS detail_pesanan, pesanan, produk, toko, pembeli CASCADE;

CREATE TABLE pembeli (
  id_pembeli   CHAR(3)      PRIMARY KEY,
  nama_pembeli VARCHAR(100) NOT NULL,
  email        VARCHAR(100) NOT NULL UNIQUE,
  no_hp        VARCHAR(20),                 -- boleh kosong (NULL)
  kota         VARCHAR(50)  NOT NULL,
  tgl_daftar   DATE         NOT NULL
);

CREATE TABLE toko (
  id_toko   CHAR(3)      PRIMARY KEY,
  nama_toko VARCHAR(100) NOT NULL,
  kota_toko VARCHAR(50)  NOT NULL
);

CREATE TABLE produk (
  id_produk     CHAR(4)       PRIMARY KEY,
  nama_produk   VARCHAR(100)  NOT NULL,
  kategori      VARCHAR(30)   NOT NULL,
  harga_katalog NUMERIC(12,2) NOT NULL CHECK (harga_katalog > 0),
  stok          INTEGER       NOT NULL DEFAULT 0 CHECK (stok >= 0),
  id_toko       CHAR(3)       NOT NULL REFERENCES toko(id_toko)
);

CREATE TABLE pesanan (
  id_pesanan   VARCHAR(10)  PRIMARY KEY,
  tgl_pesanan  DATE         NOT NULL,
  id_pembeli   CHAR(3)      NOT NULL REFERENCES pembeli(id_pembeli),
  alamat_kirim VARCHAR(200) NOT NULL,
  kurir        VARCHAR(20)  NOT NULL,
  status       VARCHAR(12)  NOT NULL DEFAULT 'Diproses'
               CHECK (status IN ('Diproses', 'Dikirim', 'Selesai', 'Dibatalkan'))
);

CREATE TABLE detail_pesanan (
  id_pesanan      VARCHAR(10)   NOT NULL REFERENCES pesanan(id_pesanan),
  id_produk       CHAR(4)       NOT NULL REFERENCES produk(id_produk),
  jumlah          INTEGER       NOT NULL CHECK (jumlah > 0),
  harga_saat_beli NUMERIC(12,2) NOT NULL,
  PRIMARY KEY (id_pesanan, id_produk)
);

INSERT INTO pembeli VALUES
  ('P01', 'Nadia Putri',      'nadia.p@mail.id',  '0812-1100-2211', 'Bandung',    '2025-11-03'),
  ('P02', 'Fajar Nugroho',    'fajar.n@mail.id',  NULL,             'Semarang',   '2025-12-15'),
  ('P03', 'Rizky Ramadhan',   'rizky.r@mail.id',  '0813-4455-6677', 'Jakarta',    '2026-01-08'),
  ('P04', 'Maya Sari',        'maya.s@mail.id',   NULL,             'Surabaya',   '2026-01-20'),
  ('P05', 'Dimas Pratama',    'dimas.p@mail.id',  '0857-3322-1100', 'Bogor',      '2026-02-11'),
  ('P06', 'Anisa Rahmawati',  'anisa.r@mail.id',  '0878-9900-1122', 'Yogyakarta', '2026-03-02'),
  ('P07', 'Yusuf Hakim',      'yusuf.h@mail.id',  NULL,             'Medan',      '2026-04-18'),
  ('P08', 'Lestari Wulandari','lestari.w@mail.id','0896-5544-3322', 'Bogor',      '2026-05-25');

INSERT INTO toko VALUES
  ('TK1', 'Batik Pekalongan Jaya', 'Pekalongan'),
  ('TK2', 'Gadget Murah ID',       'Jakarta'),
  ('TK3', 'Kopi Gayo Aceh',        'Takengon'),
  ('TK4', 'Dapur Bunda',           'Bandung'),
  ('TK5', 'Rajut Cantik',          'Bogor');

INSERT INTO produk VALUES
  ('PR01', 'Kemeja Batik Pria',       'Fashion',    185000,  40, 'TK1'),
  ('PR02', 'Kain Batik Tulis',        'Fashion',    350000,  12, 'TK1'),
  ('PR03', 'Earbuds TWS X1',          'Elektronik', 229000,  25, 'TK2'),
  ('PR04', 'Powerbank 10000mAh',      'Elektronik', 159000,  60, 'TK2'),
  ('PR05', 'Kabel USB-C 1m',          'Elektronik',  35000, 150, 'TK2'),
  ('PR06', 'Smartwatch Fit S2',       'Elektronik', 499000,   8, 'TK2'),
  ('PR07', 'Kopi Gayo Arabika 250g',  'Makanan',     95000,  70, 'TK3'),
  ('PR08', 'Kopi Gayo Robusta 250g',  'Makanan',     75000,   0, 'TK3'),
  ('PR09', 'Sambal Roa Botol',        'Makanan',     45000,  35, 'TK4'),
  ('PR10', 'Keripik Tempe Pedas',     'Makanan',     20000, 100, 'TK4'),
  ('PR11', 'Daster Batik Cap',        'Fashion',    120000,  30, 'TK1'),
  ('PR12', 'Mouse Wireless M2',       'Elektronik',  89000,  45, 'TK2');

INSERT INTO pesanan VALUES
  ('ORD-001', '2026-05-02', 'P01', 'Jl. Dago 21, Bandung',         'JNE',      'Selesai'),
  ('ORD-002', '2026-05-03', 'P02', 'Jl. Pemuda 8, Semarang',       'SiCepat',  'Selesai'),
  ('ORD-003', '2026-05-20', 'P01', 'Jl. A. Yani 3, Cirebon',       'J&T',      'Selesai'),
  ('ORD-004', '2026-05-22', 'P03', 'Jl. Kemang Raya 10, Jakarta',  'JNE',      'Selesai'),
  ('ORD-005', '2026-06-01', 'P04', 'Jl. Darmo 45, Surabaya',       'SiCepat',  'Selesai'),
  ('ORD-006', '2026-06-05', 'P03', 'Jl. Kemang Raya 10, Jakarta',  'J&T',      'Dibatalkan'),
  ('ORD-007', '2026-06-10', 'P05', 'Jl. Pajajaran 7, Bogor',       'JNE',      'Selesai'),
  ('ORD-008', '2026-06-14', 'P06', 'Jl. Kaliurang 12, Yogyakarta', 'AnterAja', 'Dikirim'),
  ('ORD-009', '2026-06-18', 'P02', 'Jl. Pemuda 8, Semarang',       'SiCepat',  'Dikirim'),
  ('ORD-010', '2026-06-20', 'P04', 'Jl. Darmo 45, Surabaya',       'JNE',      'Diproses'),
  ('ORD-011', '2026-06-21', 'P01', 'Jl. Dago 21, Bandung',         'AnterAja', 'Diproses');

INSERT INTO detail_pesanan VALUES
  ('ORD-001', 'PR01', 2, 175000), ('ORD-001', 'PR03', 1, 229000),
  ('ORD-002', 'PR04', 1, 159000),
  ('ORD-003', 'PR01', 1, 185000), ('ORD-003', 'PR02', 1, 350000), ('ORD-003', 'PR04', 2, 149000),
  ('ORD-004', 'PR06', 1, 499000), ('ORD-004', 'PR05', 2,  35000),
  ('ORD-005', 'PR07', 3,  95000), ('ORD-005', 'PR09', 2,  45000), ('ORD-005', 'PR10', 5,  20000),
  ('ORD-006', 'PR03', 1, 229000),
  ('ORD-007', 'PR11', 2, 120000), ('ORD-007', 'PR08', 1,  75000),
  ('ORD-008', 'PR07', 2,  90000), ('ORD-008', 'PR10', 3,  20000),
  ('ORD-009', 'PR05', 3,  35000), ('ORD-009', 'PR03', 1, 219000),
  ('ORD-010', 'PR02', 1, 350000),
  ('ORD-011', 'PR09', 4,  45000), ('ORD-011', 'PR07', 1,  95000);

-- Cek cepat: seharusnya 8, 5, 12, 11, 21
SELECT (SELECT COUNT(*) FROM pembeli) AS pembeli, (SELECT COUNT(*) FROM toko) AS toko,
       (SELECT COUNT(*) FROM produk) AS produk, (SELECT COUNT(*) FROM pesanan) AS pesanan,
       (SELECT COUNT(*) FROM detail_pesanan) AS detail;

SELECT * FROM toko;
SELECT * FROM pembeli;
SELECT * FROM produk;
SELECT * FROM pesanan;

SELECT nama_produk, kategori, harga_katalog FROM produk;

SELECT nama_produk, harga_katalog * stok AS nilai_stok, harga_katalog * 0.9 AS harga_diskon, nama_produk|| '-' || kategori AS label
FROM produk;

SELECT DISTINCT kategori 
FROM produk
ORDER BY kategori;

SELECT nama_produk, stok
FROM produk
WHERE stok = 0;

SELECT nama_produk, harga_katalog, stok
FROM produk
WHERE kategori = 'Elektronik' AND harga_katalog < 200000;

SELECT nama_produk, kategori, harga_katalog
FROM produk
WHERE (kategori = 'Makanan' OR kategori = 'Fashion') AND harga_katalog > 150000;

SELECT id_produk, nama_produk
FROM produk
WHERE id_produk LIKE 'PR1_';

SELECT nama_produk FROM produk WHERE nama_produk LIKE '%batik%';

SELECT nama_produk FROM produk WHERE nama_produk ILIKE '%batik%';

SELECT id_pesanan, kurir, status 
FROM pesanan 
WHERE kurir IN ('JNE', 'J&T')
	AND status NOT IN ('Dibatalkan');

SELECT id_pesanan, tgl_pesanan, status 
FROM pesanan 
WHERE tgl_pesanan BETWEEN '2026-06-01' AND '2026-06-15';

SELECT nama_pembeli, kota, no_hp 
FROM pembeli 
WHERE no_hp IS NULL;

SELECT nama_pembeli, kota, no_hp 
FROM pembeli 
WHERE no_hp IS NOT NULL;

SELECT nama_produk, kategori, harga_katalog 
FROM produk 
ORDER BY kategori ASC, harga_katalog DESC;

SELECT nama_produk, harga_katalog 
FROM produk 
ORDER BY harga_katalog DESC 
LIMIT 3;

SELECT nama_produk, harga_katalog 
FROM produk 
ORDER BY harga_katalog ASC 
LIMIT 3;

SELECT id_produk, nama_produk 
FROM produk 
ORDER BY id_produk 
LIMIT 4 OFFSET 4;

SELECT nama_pembeli, email
FROM pembeli
WHERE kota = 'Bogor';

SELECT nama_produk, stok
FROM produk
WHERE kategori = 'Makanan'
  AND stok < 50
ORDER BY stok;

SELECT id_pesanan, tgl_pesanan, kurir
FROM pesanan
WHERE tgl_pesanan BETWEEN '2026-05-01' AND '2026-05-31'
  AND kurir IN ('JNE', 'J&T');

SELECT nama_pembeli, no_hp
FROM pembeli
WHERE no_hp IS NOT NULL
ORDER BY nama_pembeli
LIMIT 3;

SELECT nama_produk,
       harga_katalog * stok AS nilai_stok
FROM produk
WHERE nama_produk ILIKE '%kopi%';

SELECT p.nama_produk, p.harga_katalog, t.nama_toko, t.kota_toko
FROM produk p
INNER JOIN toko t ON t.id_toko = p.id_toko
ORDER BY t.nama_toko, p.nama_produk;

SELECT ps.id_pesanan, ps.tgl_pesanan, pb.nama_pembeli, pr.nama_produk,
	d.jumlah, d.harga_saat_beli,
	d.jumlah * d.harga_saat_beli AS subtotal
FROM pesanan ps
JOIN pembeli pb ON pb.id_pembeli = ps.id_pembeli
JOIN detail_pesanan d ON d.id_pesanan = ps.id_pesanan
JOIN produk pr ON pr.id_produk = d.id_produk
WHERE ps.id_pesanan IN ('ORD-001', 'ORD-003')
ORDER BY ps.id_pesanan, pr.nama_produk;

SELECT pb.id_pembeli, pb.nama_pembeli, ps.id_pesanan
FROM pembeli pb
LEFT JOIN pesanan ps ON ps.id_pembeli = pb.id_pembeli
ORDER BY pb.id_pembeli, ps.id_pesanan;

SELECT pb.id_pembeli, pb.nama_pembeli, pb.tgl_daftar
FROM pembeli pb
LEFT JOIN pesanan ps ON ps.id_pembeli = pb.id_pembeli
WHERE ps.id_pesanan IS NULL;

SELECT pr.id_produk, pr.nama_produk, pr.stok
FROM produk pr
LEFT JOIN detail_pesanan d ON d.id_produk = pr.id_produk
WHERE d.id_produk IS NULL;

SELECT t.nama_toko, p.nama_produk
FROM produk p
RIGHT JOIN toko t ON t.id_toko = p.id_toko
WHERE p.id_produk IS NULL;

SELECT t.id_toko, t.nama_toko, COUNT(p.id_produk) AS jml_produk
FROM toko t
FULL JOIN produk p ON p.id_toko = t.id_toko
GROUP BY t.id_toko, t.nama_toko
ORDER BY t.id_toko;

SELECT k.kategori, u.kurir
FROM (SELECT DISTINCT kategori FROM produk) k
CROSS JOIN (SELECT DISTINCT kurir FROM pesanan) u
ORDER BY k.kategori, u.kurir;

SELECT COUNT(*) AS jml_produk,
	MIN(harga_katalog) AS termurah,
	MAX(harga_katalog) AS termahal,
	ROUND(AVG(harga_katalog), 2) AS rata_rata,
	SUM(stok) AS total_stok
FROM produk;

SELECT COUNT(*) AS jumlah_pembeli, COUNT(no_hp) AS punya_no_hp
FROM pembeli;

SELECT kategori,
	COUNT(*) AS jml_produk,
	ROUND(AVG(harga_katalog)) AS rata_harga
FROM produk
GROUP BY kategori
ORDER BY kategori;

SELECT id_pesanan,
	COUNT(*) AS jml_item,
	SUM(jumlah * harga_saat_beli) AS total
FROM detail_pesanan
GROUP BY id_pesanan
ORDER BY id_pesanan;

SELECT t.nama_toko,
	COUNT(DISTINCT d.id_pesanan) AS jml_pesanan,
	SUM(d.jumlah * d.harga_saat_beli) AS omzet
FROM toko t
JOIN produk p ON p.id_toko = t.id_toko
JOIN detail_pesanan d ON d.id_produk = p.id_produk
JOIN pesanan ps ON ps.id_pesanan = d.id_pesanan
WHERE ps.status <> 'Dibatalkan'
GROUP BY t.nama_toko
ORDER BY omzet DESC;

SELECT pb.nama_pembeli,
	COUNT(DISTINCT ps.id_pesanan) AS jml_pesanan,
	SUM(d.jumlah * d.harga_saat_beli) AS total_belanja
FROM pembeli pb
JOIN pesanan ps ON ps.id_pembeli = pb.id_pembeli
JOIN detail_pesanan d ON d.id_pesanan = ps.id_pesanan
WHERE ps.status <> 'Dibatalkan'
GROUP BY pb.nama_pembeli
HAVING SUM(d.jumlah * d.harga_saat_beli) > 500000
ORDER BY total_belanja DESC;

-- Latihan Blok 4
SELECT p.nama_produk, t.nama_toko, p.harga_katalog
FROM produk p JOIN toko t ON t.id_toko = p.id_toko
WHERE t.kota_toko = 'Jakarta' AND p.harga_katalog > 100000;

SELECT kurir, COUNT(*) AS jml_pesanan
FROM pesanan
GROUP BY kurir
ORDER BY jml_pesanan DESC;

SELECT pr.nama_produk, SUM(d.jumlah) AS unit_terjual
FROM detail_pesanan d
JOIN produk pr ON pr.id_produk = d.id_produk
JOIN pesanan ps ON ps.id_pesanan = d.id_pesanan
WHERE ps.status <> 'Dibatalkan'
GROUP BY pr.nama_produk
HAVING SUM(d.jumlah) >= 3
ORDER BY unit_terjual DESC, pr.nama_produk;

SELECT t.nama_toko, COUNT(p.id_produk) AS jml_produk
FROM toko t
LEFT JOIN produk p ON p.id_toko = t.id_toko
GROUP BY t.nama_toko
ORDER BY jml_produk DESC, t.nama_toko;

SELECT pb.kota, SUM(d.jumlah * d.harga_saat_beli) AS total_belanja
FROM pembeli pb
JOIN pesanan ps ON ps.id_pembeli = pb.id_pembeli
JOIN detail_pesanan d ON d.id_pesanan = ps.id_pesanan
WHERE ps.status = 'Selesai'
GROUP BY pb.kota
ORDER BY total_belanja DESC;
-- End

-- 5.1 UNION dan UNION ALL
-- 1. Semua kota yang terlibat di Pasar Nusantara
SELECT kota FROM pembeli
UNION
SELECT kota_toko FROM toko
ORDER BY kota;

-- 2. UNION ALL dengan kolom penanda
SELECT kota AS nama_kota, 'Pembeli' AS peran FROM pembeli
UNION ALL
SELECT kota_toko, 'Toko' FROM toko
ORDER BY nama_kota, peran;

-- 5.2 Subquery: Query di Dalam Query
-- 1. Subquery yang menghasilkan satu nilai
SELECT nama_produk, harga_katalog
FROM produk
WHERE harga_katalog > (SELECT AVG(harga_katalog) FROM produk)
ORDER BY harga_katalog DESC;

-- 2. Pembeli yang pernah memakai JNE
SELECT nama_pembeli
FROM pembeli
WHERE id_pembeli IN (SELECT id_pembeli FROM pesanan WHERE kurir = 'JNE')
ORDER BY nama_pembeli;

-- 5.3 EXISTS dan NOT EXISTS
-- 1. Pembeli yang pernah membeli Elektronik
SELECT pb.nama_pembeli
FROM pembeli pb
WHERE EXISTS (
	SELECT 1
	FROM pesanan ps
	JOIN detail_pesanan d ON d.id_pesanan = ps.id_pesanan
	JOIN produk p ON p.id_produk = d.id_produk
	WHERE ps.id_pembeli = pb.id_pembeli
		AND p.kategori = 'Elektronik'
)
ORDER BY pb.nama_pembeli;

-- 2. NOT EXISTS: toko yang belum punya produk
SELECT t.nama_toko
FROM toko t
WHERE NOT EXISTS (SELECT 1 FROM produk p WHERE p.id_toko = t.id_toko);

-- 5.4 ANY dan ALL
-- 1. > ALL: lebih mahal dari SEMUA produk Fashion
SELECT nama_produk, harga_katalog
FROM produk
WHERE harga_katalog > ALL (SELECT harga_katalog FROM produk WHERE kategori = 'Fashion');

-- 2. > ANY: lebih mahal dari SETIDAKNYA SATU produk Elektronik
SELECT nama_produk, kategori, harga_katalog
FROM produk
WHERE kategori <> 'Elektronik'
AND harga_katalog > ANY (SELECT harga_katalog FROM produk WHERE kategori = 'Elektronik')
ORDER BY harga_katalog;

-- 5.5 CASE: Kolom Bersyarat
-- 1. Label kelas harga
SELECT nama_produk, harga_katalog,
	CASE
		WHEN harga_katalog < 50000 THEN 'Murah'
		WHEN harga_katalog < 200000 THEN 'Sedang'
		ELSE 'Premium'
	END AS kelas_harga
FROM produk
ORDER BY harga_katalog;

-- 2. Peringatan stok untuk penjual
SELECT nama_produk, stok,
	CASE WHEN stok = 0 THEN 'Habis'
		WHEN stok < 20 THEN 'Menipis'
		ELSE 'Aman' END AS status_stok
FROM produk
WHERE stok < 40
ORDER BY stok;

-- 3. Rekap status pesanan dalam satu baris
SELECT COUNT(*) AS semua,
	SUM(CASE WHEN status = 'Selesai' THEN 1 ELSE 0 END) AS selesai,
	SUM(CASE WHEN status IN ('Diproses', 'Dikirim') THEN 1 ELSE 0 END) AS berjalan,
	SUM(CASE WHEN status = 'Dibatalkan' THEN 1 ELSE 0 END) AS batal
FROM pesanan;

-- 5.6 Bonus: Fungsi Kecil yang Sering Dibutuhkan
-- 1. Tanggal: ambil bagian dan hitung selisih hari
SELECT id_pesanan, tgl_pesanan,
	EXTRACT(MONTH FROM tgl_pesanan) AS bulan,
	DATE '2026-06-30' - tgl_pesanan AS umur_hari
FROM pesanan
WHERE status IN ('Diproses', 'Dikirim');

-- 2. Jebakan pembagian bilangan bulat
SELECT 7 / 2 AS bagi_bulat, 7 / 2.0 AS bagi_desimal, ROUND(7 / 2.0, 1) AS dibulatkan;

-- 5.7 Latihan Blok 5
-- 1. Dengan NOT EXISTS, tampilkan produk yang belum pernah dipesan siapa pun.
SELECT p.id_produk, p.nama_produk
FROM produk p
WHERE NOT EXISTS (SELECT 1 FROM detail_pesanan d WHERE d.id_produk = p.id_produk);

-- 2. Tampilkan setiap pesanan beserta totalnya, dan beri label "Besar" jika total ≥ Rp500.000, selain itu "Kecil".
SELECT id_pesanan,
	SUM(jumlah * harga_saat_beli) AS total,
	CASE WHEN SUM(jumlah * harga_saat_beli) >= 500000 THEN 'Besar' ELSE 'Kecil' END ASlabel
FROM detail_pesanan
GROUP BY id_pesanan
ORDER BY id_pesanan;

-- 3. Buat satu daftar berisi nama semua pembeli dan semua toko dalam kolomnama_pihak, dengan kolom peran yang berisi "Pembeli" atau "Toko". Urutkan berdasarkan nama.
SELECT nama_pembeli AS nama_pihak, 'Pembeli' AS peran FROM pembeli
UNION ALL
SELECT nama_toko, 'Toko' FROM toko
ORDER BY nama_pihak;
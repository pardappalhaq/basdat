-- 1. Membuat Tabel Barang
CREATE TABLE TblBarang (
    KodeBarang VARCHAR(4) PRIMARY KEY,
    NamaBarang VARCHAR(20),
    Satuan VARCHAR(1),
    Stock INT,
    HargaSatuan NUMERIC(15, 2)
);

-- 2. Membuat Tabel Pemasok
CREATE TABLE TblPemasok (
    KodePemasok VARCHAR(4) PRIMARY KEY,
    Nama VARCHAR(50),
    Alamat VARCHAR(100),
    Telepon VARCHAR(20)
);

-- 3. Membuat Tabel Transaksi (dengan relasi Foreign Key)
CREATE TABLE TblTransaksi (
    NoTransaksi VARCHAR(4) PRIMARY KEY,
    Tanggal DATE,
    KodeBarang VARCHAR(4) REFERENCES TblBarang(KodeBarang) ON DELETE CASCADE ON UPDATE CASCADE,
    KodePemasok VARCHAR(4) REFERENCES TblPemasok(KodePemasok) ON DELETE CASCADE ON UPDATE CASCADE,
    Jumlah INT,
    Harga NUMERIC(15, 2)
);

-- Insert data ke TblBarang
INSERT INTO TblBarang (KodeBarang, NamaBarang, Satuan, Stock, HargaSatuan) VALUES
('A001', 'Komputer', '1', 23, 4000000),
('A002', 'Printer', '1', 10, 900000),
('A003', 'Disket', '2', 75, 35000),
('B001', 'Terigu', '4', 20, 5000),
('C001', 'Kaca', '1', 21, 2800),
('C002', 'Papan', '3', 10, 20000),
('B002', 'Beras', '4', 10, 4500),
('C010', 'Kayu', '3', 23, 10000),
('B009', 'Gula', '4', 10, 6600),
('A011', 'Stabilizer', '1', 75, 50000),
('A004', 'Radio', '1', 15, 450000),
('A005', 'Televisi Warna 14"', '1', 20, 1200000);

-- Insert data ke TblPemasok
INSERT INTO TblPemasok (KodePemasok, Nama, Alamat, Telepon) VALUES
('P001', 'Abdul Munif', 'Jl. Sukasari 223 Bogor', '0251342644'),
('S002', 'CV Makmur Terus', 'Jl. Kenanga 5 Kav. 44 Bogor', '0251352552'),
('P002', 'PT Sumber Jaya', 'Jl. Kemerdekaan 56 Jakarta', '0218553343'),
('P003', 'CV Abadi', 'Jl. Dedali putih 32 Sukabumi', '0266532633');

-- Insert data ke TblTransaksi
INSERT INTO TblTransaksi (NoTransaksi, Tanggal, KodeBarang, KodePemasok, Jumlah, Harga) VALUES
('B001', '2006-08-23', 'A001', 'P001', 25, 87500000),
('B002', '2006-08-23', 'A002', 'S002', 12, 9600000),
('B003', '2006-08-23', 'B001', 'P002', 30, 120000),
('B004', '2006-08-25', 'C001', 'P003', 25, 37500),
('B005', '2006-08-25', 'C002', 'P003', 20, 240000),
('B006', '2006-08-28', 'B009', 'S002', 30, 174000),
('B007', '2006-08-29', 'B002', 'P002', 50, 200000),
('B008', '2006-08-29', 'C010', 'P003', 30, 210000);

-- 1. Tampilkan daftar pemasok (kodePemasok, NamaPemasok, ALmt) yang memasok barang Disket atau terigu
SELECT DISTINCT 
    p.KodePemasok, 
    p.Nama AS NamaPemasok, 
    p.Alamat AS ALmt
FROM TblTransaksi t
JOIN TblPemasok p ON t.KodePemasok = p.KodePemasok
JOIN TblBarang b ON t.KodeBarang = b.KodeBarang
WHERE b.NamaBarang ILIKE 'Disket' OR b.NamaBarang ILIKE 'Terigu';

-- 2. Tampilkan banyaknya transaksi pada tanggal 23/8/2006
SELECT COUNT(*) AS banyak_transaksi
FROM TblTransaksi
WHERE Tanggal = '2006-08-23';

-- 3. Tampilkan banyaknya transaksi pada bulan agustus (tanggal dan tahunnya sembarang, yang penting bulan agustus)
SELECT COUNT(*) AS banyak_transaksi_agustus
FROM TblTransaksi
WHERE EXTRACT(MONTH FROM Tanggal) = 8;

-- 4. Tampilkan jumlah transaksi terkecil yang dilakukan pemasok CV Makmur Terus
SELECT MIN(t.Jumlah) AS jumlah_transaksi_terkecil
FROM TblTransaksi t
JOIN TblPemasok p ON t.KodePemasok = p.KodePemasok
WHERE p.Nama ILIKE 'CV Makmur Terus';

-- 5. Tampilkan harga satuan barang terbesar
SELECT MAX(HargaSatuan) AS harga_satuan_terbesar
FROM TblBarang;

-- 6. Tampilkan nama barang, nama pemasok, jumlah transaksi yang jml transaksi > 50 dan diurutkan berdasarkan jumlah transaksi secara desc
SELECT 
    b.NamaBarang, 
    p.Nama AS NamaPemasok, 
    t.Jumlah AS jumlah_transaksi
FROM TblTransaksi t
JOIN TblBarang b ON t.KodeBarang = b.KodeBarang
JOIN TblPemasok p ON t.KodePemasok = p.KodePemasok
WHERE t.Jumlah > 50
ORDER BY t.Jumlah DESC;

-- 7. Tampilkan daftar barang yang stocknya antara 25 sampai 100
SELECT *
FROM TblBarang
WHERE Stock BETWEEN 25 AND 100;

-- 8. Tampilkan daftar pemasok yang alamatnya di bogor!
SELECT *
FROM TblPemasok
WHERE Alamat ILIKE '%Bogor%';

-- 9. Tampilkan daftar barang selain disket dan terigu.
SELECT *
FROM TblBarang
WHERE NamaBarang NOT ILIKE 'Disket' 
  AND NamaBarang NOT ILIKE 'Terigu';
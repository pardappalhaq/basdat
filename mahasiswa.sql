CREATE TABLE TblMahasiswa (
    NRP VARCHAR(10) PRIMARY KEY,
    Nama VARCHAR(50),
    KotaAsal VARCHAR(50),
    AnakKe INT,
    TmpLahir VARCHAR(50),
    TglLahir DATE,
    Agama VARCHAR(20),
    Hobi INT
);

CREATE TABLE TblKuliah (
    KodeKuliah VARCHAR(10) PRIMARY KEY,
    NamaKuliah VARCHAR(100),
    sks INT,
    Semester INT
);

CREATE TABLE TblHasilBelajar (
    idhasilbelajar INT PRIMARY KEY,
    NRP VARCHAR(10) REFERENCES TblMahasiswa(NRP) ON DELETE CASCADE ON UPDATE CASCADE,
    KodeKuliah VARCHAR(10) REFERENCES TblKuliah(KodeKuliah) ON DELETE CASCADE ON UPDATE CASCADE,
    NilaiUTS INT,
    NilaiUAS INT
);

INSERT INTO TblMahasiswa (NRP, Nama, KotaAsal, AnakKe, TmpLahir, TglLahir, Agama) VALUES
('G001', 'Lastri', 'Bogor', 1, 'Bogor', '1988-12-05', 'Islam'),
('G002', 'Iwan', 'Bekasi', 2, 'Jakarta', '1987-04-12', 'Kristen'),
('G003', 'Sharly', 'Surabaya', 4, 'Yogyakarta', '1988-07-04', 'Hindu'),
('G004', 'Anto', 'Solo', 2, 'Bandung', '1988-06-08', 'Islam'),
('G005', 'Sinta', 'Jombang', 3, 'Jombang', '1987-09-02', 'Islam'),
('G006', 'Didik', 'Surabaya', 1, 'Surabaya', '1987-01-07', 'Budha'),
('G007', 'sinta', 'Solo', 2, 'Bogor', '1989-04-09', 'Budha');

-- Insert data ke TblKuliah
INSERT INTO TblKuliah (KodeKuliah, NamaKuliah, sks, Semester) VALUES
('TEK303', 'Manajemen Basis Data', 3, 3),
('DIP108', 'Aplikasi Komputer', 3, 1),
('TEK601', 'Sistem Informasi', 2, 6),
('TEK202', 'Pengantar Organisasi Komputer', 2, 2);

-- Insert data ke TblHasilBelajar
INSERT INTO TblHasilBelajar (idhasilbelajar, NRP, KodeKuliah, NilaiUTS, NilaiUAS) VALUES
(1, 'G001', 'TEK303', 70, 65),
(2, 'G001', 'DIP108', 60, 80),
(3, 'G001', 'TEK202', 55, 50),
(4, 'G003', 'TEK303', 56, 70),
(5, 'G003', 'TEK202', 80, 65),
(6, 'G004', 'TEK601', 54, 80),
(7, 'G004', 'TEK202', 40, 60),
(8, 'G004', 'DIP108', 80, 60),
(9, 'G007', 'TEK303', 80, 50),
(10, 'G007', 'TEK601', 70, 70),
(11, 'G007', 'TEK202', 65, 55);

-- Tampilkan data mahasiswa berdasarkan urutan anak ke secara descending
SELECT * 
FROM TblMahasiswa 
ORDER BY AnakKe DESC;

-- Tampilkan banyaknya record mahasiswa
SELECT COUNT(*) AS jumlah_mahasiswa 
FROM TblMahasiswa;

-- Tampilkan banyaknya mahasiswa yang beragama Islam
SELECT COUNT(*) AS jumlah_mahasiswa_islam 
FROM TblMahasiswa 
WHERE Agama = 'Islam';

-- Tampilkan tanggal lahir yang paling tua yang ada di TblMahasiswa
SELECT MIN(TglLahir) AS tanggal_lahir_paling_tua 
FROM TblMahasiswa;

-- Tampilkan nilai UAS terbesar yang diperoleh mahasiswa untuk mata kuliah Aplikasi Komputer
-- Cara 1: Menggunakan JOIN
SELECT MAX(hb.NilaiUAS) AS nilai_uas_terbesar
FROM TblHasilBelajar hb
JOIN TblKuliah k ON hb.KodeKuliah = k.KodeKuliah
WHERE k.NamaKuliah = 'Aplikasi Komputer';

-- Cara 2: Menggunakan KodeKuliah langsung
SELECT MAX(NilaiUAS) AS nilai_uas_terbesar
FROM TblHasilBelajar
WHERE KodeKuliah = 'DIP108';

-- 10. Tampilkan NIM, Nama, KodeMk, NilaiUTS, NilaiUAS, diurutkan berdasarkan NIM secara descending dan NilaiUTS secara ascending
SELECT 
    m.NRP AS "NIM", 
    m.Nama, 
    hb.KodeKuliah AS "KodeMk", 
    hb.NilaiUTS, 
    hb.NilaiUAS
FROM TblHasilBelajar hb
JOIN TblMahasiswa m ON hb.NRP = m.NRP
ORDER BY m.NRP DESC, hb.NilaiUTS ASC;

-- 11. Tampilkan nilai UTS terbesar, nilai UTS terkecil, dan rata-rata nilai UTS mata kuliah dengan kode DIP108!
SELECT 
    MAX(NilaiUTS) AS "Nilai_MAks", 
    MIN(NilaiUTS) AS "Nilai_MIN", 
    ROUND(AVG(NilaiUTS), 2) AS "Rata-rata"
FROM TblHasilBelajar
WHERE KodeKuliah = 'DIP108';
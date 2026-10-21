-- BAGIAN A | DDL
-- A1
CREATE DATABASE kuis_J0403251042;

-- A2
DROP TABLE IF EXISTS detail_sewa, sewa, alat, pelanggan, kategori_alat CASCADE;

-- A3
CREATE TABLE kategori_alat (
    kode_kategori CHAR(2) PRIMARY KEY,
    nama_kategori VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE pelanggan (
    id_pelanggan CHAR(3) PRIMARY KEY,
    nama_pelanggan VARCHAR(60) NOT NULL,
    no_hp VARCHAR(20) NOT NULL UNIQUE,
    kota VARCHAR(40) NOT NULL
);

CREATE TABLE alat (
    kode_alat CHAR(4) PRIMARY KEY,
    nama_alat VARCHAR(60) NOT NULL,
    kode_kategori CHAR(2) NOT NULL,
    tarif_harian NUMERIC(10,2) NOT NULL CHECK (tarif_harian > 0),
    stok SMALLINT NOT NULL DEFAULT 0 CHECK (stok >= 0),
    FOREIGN KEY (kode_kategori) REFERENCES kategori_alat(kode_kategori)
);

CREATE TABLE sewa (
    no_sewa VARCHAR(10) PRIMARY KEY,
    tgl_sewa DATE NOT NULL,
    tgl_kembali_rencana DATE NOT NULL,
    id_pelanggan CHAR(3) NOT NULL,
    status VARCHAR(12) NOT NULL DEFAULT 'Berjalan',
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
    CHECK (tgl_kembali_rencana > tgl_sewa),
    CHECK (status IN ('Berjalan', 'Selesai', 'Batal'))
);

CREATE TABLE detail_sewa (
    no_sewa VARCHAR(10),
    kode_alat CHAR(4),
    jumlah SMALLINT NOT NULL CHECK (jumlah > 0),
    tarif_saat_sewa NUMERIC(10,2) NOT NULL CHECK (tarif_saat_sewa > 0),
    PRIMARY KEY (no_sewa, kode_alat),
    FOREIGN KEY (no_sewa) REFERENCES sewa(no_sewa),
    FOREIGN KEY (kode_alat) REFERENCES alat(kode_alat)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'detail_sewa'
ORDER BY ordinal_position;

-- BAGIAN B | DML
-- B1
INSERT INTO kategori_alat (kode_kategori, nama_kategori) VALUES
('MK', 'Peralatan Masak'),
('PN', 'Penerangan'),
('TD', 'Tenda'),
('TR', 'Perlengkapan Tidur');

INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, no_hp, kota) VALUES
('P01', 'Bayu Saputra', '0812-3344-5566', 'Bogor'),
('P02', 'Sinta Marlina', '0857-9900-1122', 'Depok'),
('P03', 'Rangga Pratama', '0896-4455-7788', 'Bogor'),
('P04', 'Mega Lestari', '0813-1100-2299', 'Tangerang');

INSERT INTO alat (kode_alat, nama_alat, kode_kategori, tarif_harian, stok) VALUES
('A001', 'Tenda Dome 4 Orang', 'TD', 75000, 5),
('A002', 'Tenda Dome 2 Orang', 'TD', 50000, 8),
('A003', 'Lampu Tenda LED', 'PN', 15000, 20),
('A004', 'Headlamp', 'PN', 10000, 15),
('A005', 'Kompor Portable', 'MK', 25000, 6),
('A006', 'Nesting Set', 'MK', 20000, 10),
('A007', 'Sleeping Bag', 'TR', 25000, 12),
('A008', 'Matras Gulung', 'TR', 10000, 0);

INSERT INTO sewa (no_sewa, tgl_sewa, tgl_kembali_rencana, id_pelanggan, status) VALUES
('SW-001', '2026-10-02', '2026-10-05', 'P01', 'Selesai'),
('SW-002', '2026-10-03', '2026-10-06', 'P02', 'Berjalan'),
('SW-003', '2026-10-09', '2026-10-12', 'P01', 'Berjalan'),
('SW-004', '2026-10-10', '2026-10-11', 'P03', 'Batal');

INSERT INTO detail_sewa (no_sewa, kode_alat, jumlah, tarif_saat_sewa) VALUES
('SW-001', 'A001', 1, 75000),
('SW-001', 'A003', 2, 15000),
('SW-001', 'A005', 1, 25000),
('SW-002', 'A002', 2, 50000),
('SW-002', 'A007', 2, 25000),
('SW-003', 'A001', 1, 75000),
('SW-004', 'A004', 2, 10000);

-- B2
INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, no_hp, kota)
VALUES ('P05', 'Faris Daffa Al Haq', '0851-3646-7086', 'Bogor');

-- B3
-- Status sengaja tidak dicantumkan agar memakai DEFAULT 'Berjalan'
INSERT INTO sewa (no_sewa, tgl_sewa, tgl_kembali_rencana, id_pelanggan)
VALUES ('SW-042', '2026-10-15', '2026-10-18', 'P05');

INSERT INTO detail_sewa (no_sewa, kode_alat, jumlah, tarif_saat_sewa) VALUES
('SW-042', 'A001', 1, 75000),
('SW-042', 'A003', 2, 15000);

-- BAGIAN C | ALTER TABLE, UPDATE, DELETE
-- C1
ALTER TABLE pelanggan
ADD COLUMN email VARCHAR(80);

-- C2
UPDATE pelanggan
SET email = 'bayu.saputra@mail.id'
WHERE id_pelanggan = 'P01';

UPDATE pelanggan
SET email = 'sinta.marlina@mail.id'
WHERE id_pelanggan = 'P02';

UPDATE pelanggan
SET no_hp = '0851-3646-7086'
WHERE id_pelanggan = 'P05';

-- C3
UPDATE alat
SET tarif_harian = tarif_harian * 1.20
WHERE kode_alat = 'A003'
RETURNING kode_alat, nama_alat, tarif_harian;

-- C4
UPDATE sewa
SET status = 'Selesai'
WHERE no_sewa = 'SW-002';

-- C5
DELETE FROM detail_sewa
WHERE no_sewa = 'SW-004';

DELETE FROM sewa
WHERE no_sewa = 'SW-004';

-- BAGIAN D | SELECT
-- D1
SELECT kode_alat, nama_alat, tarif_harian
FROM alat
ORDER BY tarif_harian DESC;

-- D2
SELECT kode_alat, nama_alat, kode_kategori, tarif_harian, stok
FROM alat
WHERE kode_kategori = 'PN';

-- D3
SELECT kode_alat, nama_alat, stok
FROM alat
WHERE stok = 0;

-- D4
SELECT nama_pelanggan AS "Nama Pelanggan",
       no_hp AS "Kontak"
FROM pelanggan
WHERE kota = 'Bogor';

-- D5
SELECT DISTINCT kota
FROM pelanggan
ORDER BY kota ASC;

-- D6
SELECT id_pelanggan, nama_pelanggan, no_hp, kota, email
FROM pelanggan
WHERE email IS NULL;

-- D7
SELECT no_sewa, tgl_sewa, tgl_kembali_rencana, id_pelanggan, status
FROM sewa
WHERE tgl_sewa BETWEEN '2026-10-01' AND '2026-10-09'
ORDER BY tgl_sewa;

-- D8
SELECT no_sewa,
       kode_alat,
       jumlah,
       tarif_saat_sewa,
       jumlah * tarif_saat_sewa AS subtotal
FROM detail_sewa
ORDER BY subtotal DESC;

-- BAGIAN E | UJI CONSTRAINT
-- E1
INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, no_hp, kota)
VALUES ('P01', 'Pelanggan Duplikat', '0800-0000-0000', 'Bogor');

-- ERROR: duplicate key value violates unique constraint "pelanggan_pkey"
-- DETAIL: Key (id_pelanggan)=(P01) already exists.
-- Penjelasan: PRIMARY KEY memastikan setiap id_pelanggan unik.

-- E2
INSERT INTO sewa (no_sewa, tgl_sewa, tgl_kembali_rencana, id_pelanggan)
VALUES ('SW-099', '2026-10-20', '2026-10-22', 'P99');

-- ERROR: insert or update on table "sewa" violates foreign key constraint
-- "sewa_id_pelanggan_fkey"
-- Penjelasan: FOREIGN KEY memastikan id_pelanggan yang digunakan
-- pada tabel sewa harus sudah terdaftar pada tabel pelanggan.

-- E3
INSERT INTO detail_sewa (no_sewa, kode_alat, jumlah, tarif_saat_sewa)
VALUES ('SW-001', 'A006', 0, 20000);

-- ERROR: new row for relation "detail_sewa" violates check constraint
-- "detail_sewa_jumlah_check"
-- DETAIL: Failing row contains (SW-001, A006, 0, 20000.00).
-- Penjelasan: aturan bisnis no. 7 mewajibkan jumlah minimal satu,
-- sehingga CHECK (jumlah > 0) menolak baris ini.

-- VERIFIKASI AKHIR
-- Hasil yang diharapkan: kategori=4, pelanggan=5,
-- alat=8, sewa=4, detail=8

SELECT
    (SELECT COUNT(*) FROM kategori_alat) AS kategori,
    (SELECT COUNT(*) FROM pelanggan) AS pelanggan,
    (SELECT COUNT(*) FROM alat) AS alat,
    (SELECT COUNT(*) FROM sewa) AS sewa,
    (SELECT COUNT(*) FROM detail_sewa) AS detail;
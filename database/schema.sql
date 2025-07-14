-- Active: 1752475352370@@127.0.0.1@3306@simkam
USE simkam;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(120) NOT NULL UNIQUE,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255),
    role ENUM('admin', 'mahasiswa', 'dosen', 'staff'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE gedung (
    gedung_id VARCHAR(60) PRIMARY KEY,
    nama_gedung VARCHAR(120)
);

CREATE TABLE departemen (
    departemen_id VARCHAR(60) PRIMARY KEY,
    departemen VARCHAR(120),
    gedung_id VARCHAR(60),
    FOREIGN KEY (gedung_id) REFERENCES gedung (gedung_id)
);

CREATE TABLE unit (
    unit_id VARCHAR (60) PRIMARY KEY,
    unit VARCHAR (120),
    departemen_id VARCHAR(60),
    FOREIGN KEY (departemen_id) REFERENCES departemen (departemen_id)
);

CREATE TABLE ruang (
    ruang_id VARCHAR(10) PRIMARY KEY,
    ruang VARCHAR (120),
    gedung_id VARCHAR(60),
    unit_id VARCHAR(60),
    FOREIGN KEY (gedung_id) REFERENCES gedung (gedung_id),
    FOREIGN KEY (unit_id) REFERENCES unit (unit_id)
);

CREATE TABLE prodi (
    prodi_id VARCHAR(120) PRIMARY KEY,
    nama_prodi VARCHAR(120),
    gedung_id VARCHAR(120),
    akreditasi VARCHAR(50),
    FOREIGN KEY (gedung_id) REFERENCES gedung (gedung_id)
);

CREATE TABLE dosen (
    dosen_id INT PRIMARY KEY,
    user_id INT,
    nama VARCHAR(160),
    agama VARCHAR(20),
    jenis_kelamin ENUM ('laki-laki', 'wanita'),
    tempat_lahir VARCHAR(120),
    tanggal_lahir DATE,
    alamat TEXT,
    email VARCHAR(255) UNIQUE,
    no_telp VARCHAR(13),
    nidn VARCHAR(15),
    nidk VARCHAR(15),
    status ENUM ('aktif', 'non-aktif', 'cuti'),
    kategori_dosen ENUM('tetap', 'honorer', 'luar_biasa', 'tamu'),
    foto_profil VARCHAR(160),
    gelar_depan VARCHAR(120),
    gelar_belakang VARCHAR(120),
    golongan_pangkat VARCHAR(20),
    tanggal_bergabung DATE,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE prodi_dosen (
    prodi_dosen_id INT AUTO_INCREMENT PRIMARY KEY,
    dosen_id INT,
    prodi_id VARCHAR(120),
    peran VARCHAR(120),
    tahun_mulai YEAR,
    status ENUM ('aktif', 'non-aktif'),
    FOREIGN KEY (prodi_id) REFERENCES prodi (prodi_id),
    FOREIGN KEY (dosen_id) REFERENCES dosen (dosen_id)
);

CREATE TABLE dpa (
    dpa_id INT AUTO_INCREMENT PRIMARY KEY,
    prodi_dosen_id INT,
    status ENUM ('aktif', 'non-aktif'),
    alasan_perubahan VARCHAR(260),
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    dpa_history VARCHAR(160),
    FOREIGN KEY (prodi_dosen_id) REFERENCES prodi_dosen (prodi_dosen_id)
);

CREATE TABLE mahasiswa (
    nim VARCHAR(20) PRIMARY KEY,
    user_id INT,
    nama VARCHAR(160),
    agama VARCHAR(20),
    jenis_kelamin ENUM ('laki-laki', 'perempuan'),
    tempat_lahir VARCHAR(120),
    tanggal_lahir DATE,
    alamat TEXT,
    email VARCHAR(255) UNIQUE,
    no_telp VARCHAR(13),
    prodi_id VARCHAR(120),
    dpa_id INT,
    angkatan VARCHAR(15),
    status ENUM ('aktif', 'non-aktif'),
    foto_profil VARCHAR(160),
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (prodi_id) REFERENCES prodi (prodi_id),
    FOREIGN KEY (dpa_id) REFERENCES dpa (dpa_id)
);

CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    nama VARCHAR(160),
    agama VARCHAR(20),
    jenis_kelamin ENUM ('laki-laki', 'perempuan'),
    tempat_lahir VARCHAR(120),
    tanggal_lahir DATE,
    alamat TEXT,
    email VARCHAR(255) UNIQUE,
    no_telp VARCHAR(13),
    status ENUM ('aktif', 'non-aktif'),
    foto_profil VARCHAR(160),
    kategori_staff VARCHAR(60),
    tanggal_bergabung DATE,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE pegawai (
    pegawai_id INT AUTO_INCREMENT PRIMARY KEY,
    dosen_id INT,
    staff_id INT,
    FOREIGN KEY (dosen_id) REFERENCES dosen (dosen_id),
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE jabatan (
    jabatan_id VARCHAR(20) PRIMARY KEY,
    jabatan VARCHAR(120)
);

CREATE TABLE jabatan_diambil (
    pegawai_id INT,
    jabatan_id VARCHAR(20),
    unit_id VARCHAR(60),
    status ENUM ('aktif', 'non-aktif'),
    tanggal_mulai DATE,
    tanggal_selesai DATE,
    PRIMARY KEY (pegawai_id, jabatan_id),
    FOREIGN KEY (pegawai_id) REFERENCES pegawai (pegawai_id),
    FOREIGN KEY (jabatan_id) REFERENCES jabatan (jabatan_id)
);

CREATE TABLE akademik (
    akademik_id INT AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran VARCHAR(10),
    semester INT,
    kurikulum VARCHAR(60),
    status ENUM ('on progress', 'comming soon'),
    tanggal_mulai DATE,
    tanggal_selesai DATE
);

CREATE TABLE mata_kuliah (
    mata_kuliah_id INT AUTO_INCREMENT PRIMARY KEY,
    mata_kuliah VARCHAR(120),
    deskripsi TEXT,
    status ENUM ('terlaksana', 'belum terlaksana'),
    akademik_id INT,
    sks INT,
    kategori ENUM ('wajib', 'umum'),
    prodi_id VARCHAR(120),
    prasyarat VARCHAR(120),
    FOREIGN KEY (prodi_id) REFERENCES prodi (prodi_id)
);

CREATE TABLE jadwal_kelas (
    jadwal_kelas_id INT AUTO_INCREMENT PRIMARY KEY,
    mata_kuliah_id INT,
    kapasitas INT,
    hari ENUM ('senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu'),
    jam_mulai TIME,
    jam_selesai TIME,
    ruang_id VARCHAR(10),
    dosen_id INT,
    FOREIGN KEY (mata_kuliah_id) REFERENCES mata_kuliah (mata_kuliah_id),
    FOREIGN KEY (ruang_id) REFERENCES ruang (ruang_id),
    FOREIGN KEY (dosen_id) REFERENCES dosen (dosen_id)
);

CREATE TABLE pengisian_krs (
    pengisian_krs_id INT AUTO_INCREMENT PRIMARY KEY,
    jadwal_kelas_id INT,
    nim VARCHAR(20),
    status ENUM ('pending', 'diajukan', 'approve'),
    tanggal_pengisian DATETIME DEFAULT CURRENT_TIMESTAMP,
    alasan_peruban TEXT,
    is_final BOOLEAN,
    last_update DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (jadwal_kelas_id) REFERENCES jadwal_kelas (jadwal_kelas_id),
    FOREIGN KEY (nim) REFERENCES mahasiswa (nim)
);
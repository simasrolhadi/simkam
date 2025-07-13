CREATE DATABASE simkam;

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
    gedung_id VARCHAR(120) PRIMARY KEY,
    nama_gedung VARCHAR(120)
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
    dosen_id INT,
    prodi_id VARCHAR(120),
    status ENUM ('aktif', 'non-aktif'),
    alasan_perubahan VARCHAR(260),
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    dpa_history VARCHAR(160),
    FOREIGN KEY (dosen_id) REFERENCES dosen (dosen_id),
    FOREIGN KEY (prodi_id) REFERENCES prodi (prodi_id)
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

CREATE TABLE prodi_mahasiswa (
    prodi_mahasiswa_id INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(20),
    prodi_id VARCHAR(120),
    status ENUM ('aktif', 'non-aktif'),
    tahun_mulai YEAR,
    tahun_selesai YEAR,
    FOREIGN KEY (nim) REFERENCES mahasiswa (nim),
    FOREIGN KEY (prodi_id) REFERENCES prodi (prodi_id)
);
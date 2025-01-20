-- Struktur Database untuk Sistem Koreksi Nilai Siswa

CREATE DATABASE slta_db;
USE slta_db;

-- Tabel untuk menyimpan data pengguna
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'guru') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan data mata pelajaran
CREATE TABLE mata_pelajaran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_pelajaran VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan data kelas
CREATE TABLE kelas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kelas VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan data jurusan
CREATE TABLE jurusan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_jurusan VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan data siswa
CREATE TABLE siswa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_siswa VARCHAR(100) NOT NULL,
    nis VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan data siswa per tahun ajaran
CREATE TABLE siswa_kelas_jurusan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_siswa INT NOT NULL,
    id_kelas INT NOT NULL,
    id_jurusan INT NOT NULL,
    tahun_ajaran VARCHAR(9) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_siswa) REFERENCES siswa(id),
    FOREIGN KEY (id_kelas) REFERENCES kelas(id),
    FOREIGN KEY (id_jurusan) REFERENCES jurusan(id)
);

-- Tabel untuk menyimpan data mata pelajaran per tahun ajaran
CREATE TABLE mata_pelajaran_tahun (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pelajaran INT NOT NULL,
    tahun_ajaran VARCHAR(9) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pelajaran) REFERENCES mata_pelajaran(id)
);

-- Tabel untuk menyimpan data soal
CREATE TABLE soal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pelajaran INT NOT NULL,
    jenis_soal ENUM('PG', 'ESAI') NOT NULL,
    soal_text TEXT NOT NULL,
    jawaban TEXT NOT NULL,
    bobot_nilai INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pelajaran) REFERENCES mata_pelajaran(id)
);
-- Tabel untuk menyimpan data hasil koreksi
CREATE TABLE jawaban_soal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_siswa INT NOT NULL,
    id_soal INT NOT NULL,
    jawaban TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_siswa) REFERENCES siswa(id),
    FOREIGN KEY (id_soal) REFERENCES soal(id)
);

-- Tabel untuk menyimpan data hasil koreksi
CREATE TABLE nilai_hasil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_siswa INT NOT NULL,
    id_soal INT NOT NULL,
    nilai INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_siswa) REFERENCES siswa(id),
    FOREIGN KEY (id_soal) REFERENCES soal(id)
);

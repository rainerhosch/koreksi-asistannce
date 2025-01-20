-- Data Dummy untuk Tabel `kelas`
INSERT INTO kelas (nama_kelas) 
VALUES 
('Kelas 10'), ('Kelas 11'), ('Kelas 12');

-- Data Dummy untuk Tabel `jurusan`
INSERT INTO jurusan (nama_jurusan) 
VALUES 
('IPA'), ('IPS'), ('Bahasa'), ('TKJ'), ('RPL'), ('Mesin'), ('Elektro'), ('Sipil');

-- Data Dummy untuk Tabel `mata_pelajaran`
INSERT INTO mata_pelajaran (nama_pelajaran)
VALUES 
('Matematika'), ('Fisika'), ('Kimia'), ('Biologi'), ('Sejarah'), 
('Geografi'), ('Sosiologi'), ('Bahasa Indonesia'), ('Bahasa Inggris'), 
('Pemrograman'), ('Jaringan Dasar'), ('Elektronika'), ('Mesin Dasar');

-- Data Dummy untuk Tabel `siswa`
INSERT INTO siswa (nama_siswa, nis)
SELECT 
    CONCAT('Siswa_', n) AS nama_siswa, 
    CONCAT('NIS', LPAD(n, 5, '0')) AS nis
FROM (
    SELECT @n := @n + 1 AS n FROM 
    (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) t1,
    (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) t2,
    (SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0) t3,
    (SELECT @n := 0) t4
    LIMIT 200
) nums;

-- Data Dummy untuk Tabel `siswa_kelas_jurusan` (Transaksional)
INSERT INTO siswa_kelas_jurusan (id_siswa, id_kelas, id_jurusan, tahun_ajaran)
SELECT 
    siswa.id AS id_siswa,
    FLOOR(1 + (RAND() * 3)) AS id_kelas,
    FLOOR(1 + (RAND() * 8)) AS id_jurusan,
    CONCAT(2019 + FLOOR(RAND() * 6), '/', 2020 + FLOOR(RAND() * 6)) AS tahun_ajaran
FROM siswa
ORDER BY RAND()
LIMIT 500;


-- Data Dummy untuk Tabel `mata_pelajaran_tahun` (Transaksional)
INSERT INTO mata_pelajaran_tahun (id_pelajaran, tahun_ajaran)
SELECT 
    FLOOR(1 + (RAND() * 13)) AS id_pelajaran,
    CONCAT(2019 + FLOOR(RAND() * 6), '/', 2020 + FLOOR(RAND() * 6)) AS tahun_ajaran
FROM 
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) t1,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) t2
LIMIT 500;

# Modul Tutorial: Sistem Koreksi Nilai Siswa dengan CodeIgniter 3

## Pendahuluan
Sistem koreksi nilai siswa adalah aplikasi yang dirancang untuk mempermudah administrasi nilai, mulai dari input data siswa, soal, hingga proses koreksi dan laporan. Dalam modul ini, kita akan membangun sistem lengkap menggunakan framework PHP **CodeIgniter 3**, untuk templating UI nya kita akan memakai **Bootstrap** & **jQuery**.

### Fitur Utama
- Manajemen pengguna dengan role admin dan guru.
- Input data siswa, kelas, dan jurusan.
- Input data mata pelajaran dan soal.
- Koreksi nilai otomatis berdasarkan jawaban.
- Download laporan nilai.

## Struktur Database untuk Sistem Koreksi Nilai Siswa (Koreksi Asisten)

### Tahap pertama buat database, sebagai contoh kita akan membuat koreksi_nilai_db
```sql
CREATE DATABASE koreksi_nilai_db;
USE koreksi_nilai_db;
```

### Tabel Master
1. **users**
    ```sql
    CREATE TABLE users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        role ENUM('admin', 'guru') NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ```

2. **mata_pelajaran**
    ```sql
    CREATE TABLE mata_pelajaran (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama_pelajaran VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ```

3. **kelas**
    ```sql
    CREATE TABLE kelas (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama_kelas VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ```

4. **jurusan**
    ```sql
    CREATE TABLE jurusan (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama_jurusan VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ```


5. **soal**
    ```sql
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
    ```

### Tabel Transaksional
1. **siswa**
    ```sql
    CREATE TABLE siswa (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama_siswa VARCHAR(100) NOT NULL,
        nisn VARCHAR(20) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ```

2. **siswa_kelas_jurusan**
    ```sql
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
    ```

3. **mata_pelajaran_kurikulum**
    ```sql
    CREATE TABLE mata_pelajaran_kurikulum (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_mapel INT NOT NULL,
        tahun_ajaran VARCHAR(9) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_mapel) REFERENCES mata_pelajaran(id)
    );
    ```
    
4. **ujian_jawaban**
    ```sql
    CREATE TABLE ujian_jawaban (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_siswa INT NOT NULL,
        id_soal INT NOT NULL,
        isi_jawaban TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_siswa) REFERENCES siswa(id),
        FOREIGN KEY (id_soal) REFERENCES soal(id)
    );
    ```
    
5. **nilai_hasil_ujian**
    ```sql
    CREATE TABLE nilai_hasil_ujian (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tahun_ajaran VARCHAR(9) NOT NULL,
        id_siswa INT NOT NULL,
        id_mapel INT NOT NULL,
        nilai INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_siswa) REFERENCES siswa(id),
        FOREIGN KEY (id_mapel) REFERENCES mata_pelajaran(id)
    );
    ```

## Buat Dummy Data, untuk mengisi database.
**query untuk membuat user**
```sql
INSERT INTO `users` (`username`, `password`, `role`) VALUES
('admin', '$2y$10$OeVDniPuzsnivpON5AGVr.cy0Rwc1zq6GUzl2wBGqbihJZi./ff3G', 'admin');
```


**copy query dibawah untuk mengisi beberapa tabel**
```sql
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
```


## Struktur Direktori Utama
```
project_root/
|-- application/
|   |-- config/
|   |-- controllers/
|   |-- models/
|   |-- views/
|   |-- libraries/
|   |-- helpers/
|-- assets/
|   |-- css/
|   |-- js/
|   |-- images/
|-- system/
|-- user_guide/
|-- index.php
|-- .htaccess
```

## Penjelasan Direktori dan File

### 1. `application/`
Berisi kode aplikasi utama.

#### a. `config/`
Folder ini menyimpan file konfigurasi.
- **`config.php`**: Konfigurasi dasar CodeIgniter.
- **`database.php`**: Konfigurasi koneksi database.
- **`autoload.php`**: Memuat library, helper, dan model yang diperlukan.

#### b. `controllers/`
Folder ini berisi file controller yang menangani permintaan dari pengguna.
- **`Auth.php`**: Mengelola login, logout, dan autentikasi.
- **`Dashboard.php`**: Mengelola halaman utama setelah login.
- **`Admin.php`**: Mengelola data master (user, kelas, jurusan, dll).
- **`Guru.php`**: Mengelola data siswa, soal, dan nilai.

#### c. `models/`
Folder ini berisi file model untuk manipulasi database.
- **`Auth_model.php`**: Operasi CRUD untuk tabel `users`.
- **`Admin_model.php`**: Operasi CRUD untuk data master.
- **`Guru_model.php`**: Operasi CRUD untuk data siswa, soal, dan hasil ujian.

#### d. `views/`
Folder ini menyimpan file tampilan HTML.
- **`auth/`**: Berisi halaman login.
  - `login.php`
- **`dashboard/`**: Berisi halaman utama.
  - `index.php`
- **`admin/`**: Berisi halaman untuk admin.
  - `manage_users.php`
  - `manage_kelas.php`
  - `manage_jurusan.php`
  - `manage_mapel.php`
- **`guru/`**: Berisi halaman untuk guru.
  - `manage_siswa.php`
  - `manage_soal.php`
  - `manage_nilai.php`

#### e. `libraries/`
Custom library untuk fitur tambahan (jika diperlukan).

#### f. `helpers/`
Custom helper untuk fungsi-fungsi utilitas (jika diperlukan).

### 2. `assets/`
Folder ini menyimpan file statis seperti CSS, JavaScript, dan gambar.

#### a. `css/`
Folder untuk file CSS.
- **`style.css`**: File utama untuk styling aplikasi.

#### b. `js/`
Folder untuk file JavaScript.
- **`app.js`**: File utama untuk scripting aplikasi.

#### c. `images/`
Folder untuk menyimpan gambar.

### 3. `system/`
Folder inti dari framework CodeIgniter. **Jangan diubah.**

### 4. `user_guide/`
Dokumentasi bawaan CodeIgniter.

### 5. `index.php`
File utama untuk bootstrap aplikasi.

### 6. `.htaccess`
File konfigurasi server untuk mempermudah URL routing.

## Alur Pengembangan
1. **Setup Proyek**
   - Konfigurasi file `config/config.php` dan `config/database.php`.
   - Pastikan base URL dan database sesuai dengan lingkungan lokal.

2. **Buat Controller**
   - `Auth.php` untuk autentikasi.
   - `Admin.php` dan `Guru.php` untuk fitur utama.

3. **Buat Model**
   - `Auth_model.php`, `Admin_model.php`, dan `Guru_model.php`.

4. **Buat View**
   - Halaman login di `views/auth/login.php`.
   - Halaman dashboard di `views/dashboard/index.php`.
   - Halaman manajemen data di `views/admin/` dan `views/guru/`.

5. **Tambahkan CSS dan JavaScript**
   - Gunakan file di folder `assets/` untuk desain dan interaktivitas.

6. **Testing dan Deployment**
   - Lakukan pengujian menyeluruh pada fitur aplikasi.
   - Deploy ke server dengan menyesuaikan konfigurasi di `index.php` dan `config.php`.
## Implementasi Aplikasi

### 1. Controller `Auth.php`
Controller ini mengelola autentikasi pengguna.

```php
<?php
class Auth extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Auth_model');
        $this->load->library('session');
        $this->load->helper(['url', 'form']);
    }

    public function login() {
        if ($this->session->userdata('logged_in')) {
            redirect('dashboard');
        }

        $this->load->view('auth/login');
    }

    public function login_process() {
        $username = $this->input->post('username');
        $password = $this->input->post('password');

        $user = $this->Auth_model->get_user($username);

        if ($user && password_verify($password, $user['password'])) {
            $session_data = [
                'user_id' => $user['id'],
                'username' => $user['username'],
                'role' => $user['role'],
                'logged_in' => TRUE
            ];
            $this->session->set_userdata($session_data);

            redirect('dashboard');
        } else {
            $this->session->set_flashdata('error', 'Invalid username or password');
            redirect('auth/login');
        }
    }

    public function logout() {
        $this->session->unset_userdata(['user_id', 'username', 'role', 'logged_in']);
        $this->session->sess_destroy();
        redirect('auth/login');
    }
}
```

### 2. Model `Auth_model.php`
Model ini mengelola data pengguna.

```php
<?php
class Auth_model extends CI_Model {

    public function __construct() {
        parent::__construct();
    }

    public function get_user($username) {
        $query = $this->db->get_where('users', ['username' => $username]);
        return $query->row_array();
    }

    public function create_user($data) {
        $data['password'] = password_hash($data['password'], PASSWORD_BCRYPT);
        return $this->db->insert('users', $data);
    }
}
```

### 3. View Halaman Login
Buat file `login.php` di folder `application/views/auth/`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
    <h1>Login</h1>
    <form action="<?= site_url('auth/login_process'); ?>" method="post">
        <label>Username:</label>
        <input type="text" name="username" required><br>

        <label>Password:</label>
        <input type="password" name="password" required><br>

        <button type="submit">Login</button>
    </form>

    <?php if ($this->session->flashdata('error')): ?>
        <p style="color: red;"><?= $this->session->flashdata('error'); ?></p>
    <?php endif; ?>
</body>
</html>
```

## Kesimpulan
Dengan mengikuti modul ini, Anda dapat:
1. Membuat struktur database untuk sistem koreksi nilai siswa.
2. Mengelola autentikasi pengguna.
3. Mengatur data master seperti siswa, kelas, jurusan, dan mata pelajaran.
4. Mengimplementasikan sistem koreksi nilai.

Sistem ini dapat dikembangkan lebih lanjut untuk mendukung fitur tambahan seperti analitik nilai, notifikasi, dan lainnya. Semoga bermanfaat!

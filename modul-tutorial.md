# Modul Tutorial: Sistem Koreksi Nilai Siswa dengan CodeIgniter 3

## Pendahuluan
Sistem koreksi nilai siswa adalah aplikasi yang dirancang untuk mempermudah administrasi nilai, mulai dari input data siswa, soal, hingga proses koreksi dan laporan. Dalam modul ini, kita akan membangun sistem lengkap menggunakan **CodeIgniter 3**.

### Fitur Utama
- Manajemen pengguna dengan role admin dan guru.
- Input data siswa, kelas, dan jurusan.
- Input data mata pelajaran dan soal.
- Koreksi nilai otomatis berdasarkan jawaban.
- Download laporan nilai.

## Struktur Database

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

2. **kelas**
    ```sql
    CREATE TABLE kelas (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama_kelas VARCHAR(50) NOT NULL
    );
    ```

3. **jurusan**
    ```sql
    CREATE TABLE jurusan (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama_jurusan VARCHAR(50) NOT NULL
    );
    ```

4. **mata_pelajaran**
    ```sql
    CREATE TABLE mata_pelajaran (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama_mapel VARCHAR(100) NOT NULL
    );
    ```

5. **soal**
    ```sql
    CREATE TABLE soal (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_mapel INT NOT NULL,
        pertanyaan TEXT NOT NULL,
        jawaban_benar VARCHAR(5) NOT NULL,
        FOREIGN KEY (id_mapel) REFERENCES mata_pelajaran(id)
    );
    ```

### Tabel Transaksional
1. **siswa**
    ```sql
    CREATE TABLE siswa (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama VARCHAR(100) NOT NULL,
        nis VARCHAR(50) NOT NULL UNIQUE
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
        FOREIGN KEY (id_mapel) REFERENCES mata_pelajaran(id)
    );
    ```

4. **hasil_ujian**
    ```sql
    CREATE TABLE hasil_ujian (
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_siswa INT NOT NULL,
        id_mapel INT NOT NULL,
        nilai FLOAT NOT NULL,
        tahun_ajaran VARCHAR(9) NOT NULL,
        FOREIGN KEY (id_siswa) REFERENCES siswa(id),
        FOREIGN KEY (id_mapel) REFERENCES mata_pelajaran(id)
    );
    ```

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

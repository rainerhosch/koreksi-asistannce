# Modul Tutorial: Sistem Autentikasi dengan CodeIgniter 3

## Pendahuluan
Sistem autentikasi adalah bagian penting dalam aplikasi untuk mengelola pengguna, menjaga keamanan, dan memberikan hak akses sesuai dengan peran pengguna. Modul ini menjelaskan cara membuat sistem autentikasi sederhana dengan **CodeIgniter 3**.

### Fitur yang Dibahas
- Login
- Logout
- Validasi pengguna
- Penyimpanan sesi

## Langkah 1: Membuat Tabel Database

Gunakan query berikut untuk membuat tabel `users`:

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'guru') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Langkah 2: Membuat Controller `Auth.php`
Buat file `Auth.php` di folder `application/controllers/` dengan isi berikut:

```php
<?php
// Controller: Auth.php

defined('BASEPATH') OR exit('No direct script access allowed');

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

## Langkah 3: Membuat Model `Auth_model.php`
Buat file `Auth_model.php` di folder `application/models/` dengan isi berikut:

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

## Langkah 4: Membuat View Halaman Login
Buat file `login.php` di folder `application/views/auth/` dengan isi berikut:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <h1>Login</h1>
    <form action="<?= site_url('auth/login_process'); ?>" method="post">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required><br>

        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required><br>

        <button type="submit">Login</button>
    </form>

    <?php if ($this->session->flashdata('error')): ?>
        <p style="color: red;">
            <?= $this->session->flashdata('error'); ?>
        </p>
    <?php endif; ?>
</body>
</html>
```

## Langkah 5: Konfigurasi Sesi
Pastikan konfigurasi sesi pada file `application/config/config.php` sudah diatur dengan benar:

```php
$config['sess_driver'] = 'files';
$config['sess_cookie_name'] = 'ci_session';
$config['sess_expiration'] = 7200;
$config['sess_save_path'] = sys_get_temp_dir();
$config['sess_match_ip'] = FALSE;
$config['sess_time_to_update'] = 300;
$config['sess_regenerate_destroy'] = FALSE;
```

## Langkah 6: Testing Sistem Autentikasi
1. Jalankan aplikasi di server lokal atau hosting.
2. Akses halaman login melalui URL: `http://localhost/[nama_project]/auth/login`.
3. Masukkan username dan password yang valid dari tabel `users`.
4. Jika berhasil, Anda akan diarahkan ke halaman dashboard.

## Kesimpulan
Dengan modul ini, Anda telah membuat sistem autentikasi sederhana di CodeIgniter 3. Sistem ini dapat dikembangkan lebih lanjut, misalnya dengan menambahkan fitur seperti:
- Reset Password
- Registrasi Pengguna
- Hak akses berdasarkan role.

Semoga bermanfaat dan selamat mencoba!

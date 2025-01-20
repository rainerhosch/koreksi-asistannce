<?php
// Controller: Auth.php

defined('BASEPATH') OR exit('No direct script access allowed');

class Auth extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Auth_model');
    }
    public function index() {
        // redirect('auth/login');
        if ($this->session->userdata('logged_in')) {
            redirect('dashboard');
        }

        $data['title'] = 'Login Page';
        $data['page'] = 'Auth Login';

        $this->load->view('layouts/auth', $data);
    }

    // public function generate_user(){
    //     $data = array(
    //         'username' => 'admin',
    //         'password' => '123', // Use a secure password
    //         // 'password' => password_hash('admin_password', PASSWORD_BCRYPT), // Use a secure password
    //         'role' => 'admin'
    //     );
    //     $created = $this->Auth_model->create_user($data);
    //     print_r($created);
    // }

    // public function login() {
    //     if ($this->session->userdata('logged_in')) {
    //         redirect('dashboard');
    //     }

    //     $this->load->view('layouts/auth');
    // }

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
            redirect($user['role'] === 'admin' ? 'admin' : 'guru');
        } else {
            $this->session->set_flashdata('error', 'Invalid username or password');
            redirect(base_url());
        }
    }

    public function logout() {
        $this->session->unset_userdata(['user_id', 'username', 'role', 'logged_in']);
        $this->session->sess_destroy();
        redirect(base_url());
    }
}
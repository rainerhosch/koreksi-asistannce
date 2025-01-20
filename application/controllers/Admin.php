<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Admin extends CI_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->load->model('Auth_model');
        // Ensure the user is logged in and has admin role
        if (!$this->session->userdata('logged_in') || $this->session->userdata('role') !== 'admin') {
            redirect('auth/login');
        }
    }

    public function index()
    {
        // Load the admin dashboard view
        $data['title'] = 'Dashboard Admin';
        $data['page'] = 'Admin';
        $data['slug'] = '';
        $this->load->view('layouts/template', $data);
        // $this->load->view('admin/dashboard', $data);
    }

    public function manage_users()
    {
        // Load the view to manage users
        $data['users'] = $this->Auth_model->get_all_users(); // Assuming a method to get all users
        $this->load->view('admin/manage_users', $data);
    }

    public function create_user()
    {
        // Load the view to create a new user
        $this->load->view('admin/create_user');
    }

    public function store_user()
    {
        // Process the form to create a new user
        $data = array(
            'username' => $this->input->post('username'),
            'password' => $this->input->post('password'),
            'role' => $this->input->post('role')
        );
        $this->Auth_model->create_user($data);
        redirect('admin/manage_users');
    }
}

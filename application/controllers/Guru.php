<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Guru extends CI_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model('Auth_model');
        // Ensure the user is logged in and has guru role
        if (!$this->session->userdata('logged_in') || $this->session->userdata('role') !== 'guru') {
            redirect('auth/login');
        }
    }

    public function index()
    {
        // Load the guru dashboard view
        $this->load->view('guru/dashboard');
    }

    public function manage_classes()
    {
        // Load the view to manage classes
        $data['classes'] = $this->get_classes(); // Assuming a method to get all classes
        $this->load->view('guru/manage_classes', $data);
    }

    public function create_class()
    {
        // Load the view to create a new class
        $this->load->view('guru/create_class');
    }

    public function store_class()
    {
        // Process the form to create a new class
        $data = array(
            'class_name' => $this->input->post('class_name'),
            'subject' => $this->input->post('subject'),
            'teacher_id' => $this->session->userdata('user_id')
        );
        $this->create_class_in_db($data); // Assuming a method to create class in the database
        redirect('guru/manage_classes');
    }

    private function get_classes()
    {
        // Placeholder for getting classes from the database
        return []; // Replace with actual database call
    }

    private function create_class_in_db($data)
    {
        // Placeholder for creating class in the database
        // Implement the actual database insertion logic here
    }
}

<?php
// Model: Auth_model.php
class Auth_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    public function get_user($username)
    {
        $query = $this->db->get_where('users', ['username' => $username]);
        return $query->row_array();
    }

    public function create_user($data)
    {
        $data['password'] = password_hash($data['password'], PASSWORD_DEFAULT);
        return $this->db->insert('users', $data);
    }
}
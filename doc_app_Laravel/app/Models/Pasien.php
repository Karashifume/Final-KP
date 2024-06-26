<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pasien extends Model
{
    use HasFactory;

    protected $table = 'pasien';
    //these are fillable input
    protected $fillable = [
        'user_id',
        'bio_data',
        'fav',
        'status',
        'nik',
        'nama_asli',
        'tgl_lahir',
        'alamat',
        'agama',
        'perkerjaan',
    ];

    //state this is belong to user table
    public function user(){
        return $this->belongsTo(User::class);
    }
}

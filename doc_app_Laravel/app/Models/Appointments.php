<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Appointments extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'doc_id',
        'date',
        'day',
        'time',
        'status',
        'keluhan',
        'alamat',
        'harga',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Soap extends Model
{
    use HasFactory;
    protected $fillable = [
        'appoint_id',
        'subjective',
        'objective',
        'assessment',
        'planning',
        'resep'
    ];

    //state this is belong to user table
    public function user(){
        return $this->belongsTo(User::class);
    }
}

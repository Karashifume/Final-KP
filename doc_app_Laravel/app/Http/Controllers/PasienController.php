<?php


namespace App\Http\Controllers;

use App\Models\Pasien;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PasienController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'ktp' => 'required|file|mimes:jpeg,png,jpg|max:2048',
        ]);

        $ktp = file_get_contents($request->file('ktp')->getRealPath());

        $pasien = Pasien::updateOrCreate(
            ['user_id' => Auth::user()->id],
            [
                'nik' => $request->get('nik'),
                'nama_asli' => $request->get('nama_asli'),
                'tgl_lahir' => $request->get('tgl_lahir'),
                'alamat' => $request->get('alamat'),
                'agama' => $request->get('agama'),
                'perkerjaan' => $request->get('perkerjaan'),
                'ktp' => $ktp,
            ]
        );

        return response()->json([
            'success' => 'KTP has been saved successfully!',
        ], 200);
    }
}

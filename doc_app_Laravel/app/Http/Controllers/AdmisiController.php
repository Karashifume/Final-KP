<?php

namespace App\Http\Controllers;

use App\Models\Pasien;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdmisiController extends Controller
{
    public function getUnverifiedUsers()
    {
        $unverifiedUsers = Pasien::where('verified', false)->with('user')->get();
    return response()->json($unverifiedUsers, 200);
    }

    public function verifyUser(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:pasien,user_id',
            'nik' => 'required',
            'nama_asli' => 'required',
            'tgl_lahir' => 'required',
            'alamat' => 'required',
            'agama' => 'required',
            'perkerjaan' => 'required',
        ]);

        $pasien = Pasien::where('user_id', $request->user_id)->firstOrFail();
        $pasien->update([
            'nik' => $request->nik,
            'nama_asli' => $request->nama_asli,
            'tgl_lahir' => $request->tgl_lahir,
            'alamat' => $request->alamat,
            'agama' => $request->agama,
            'perkerjaan' => $request->perkerjaan,
            'verified' => true,
        ]);

        return response()->json(['message' => 'User verified successfully!'], 200);
    }
}


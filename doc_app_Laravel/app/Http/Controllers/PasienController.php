<?php

namespace App\Http\Controllers;

use App\Models\Pasien;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
class PasienController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'nik' => 'required',
            'nama_asli' => 'required',
            'tgl_lahir' => 'required',
            'alamat' => 'required',
            'agama' => 'required',
            'perkerjaan' => 'required',
            'ktp' => 'image|mimes:jpeg,png,jpg,gif,svg|max:2048', // Validation for image
        ]);

        $user = Auth::user();

        // Check if a 'pasien' record already exists for the user
        $pasien = Pasien::where('user_id', $user->id)->first();
        if (!$pasien) {
            $pasien = new Pasien();
            $pasien->user_id = $user->id;
        }

        // Save the image
        if ($request->hasFile('ktp')) {
            $image = $request->file('ktp');
            $path = $image->store('ktp_images', 'public');
            $pasien->ktp = $path;
        }

        $pasien->nik = $request->get('nik');
        $pasien->nama_asli = $request->get('nama_asli');
        $pasien->tgl_lahir = $request->get('tgl_lahir');
        $pasien->alamat = $request->get('alamat');
        $pasien->agama = $request->get('agama');
        $pasien->perkerjaan = $request->get('perkerjaan');
        $pasien->verified = true; // Mark the patient as verified
        $pasien->save();

        return response()->json(['message' => 'Pasien data saved successfully!'], 200);
    }

    public function show()
    {
        $user = Auth::user();
        $pasien = Pasien::where('user_id', $user->id)->first();

        if ($pasien && $pasien->ktp) {
            return response()->json(['ktp' => Storage::url($pasien->ktp)], 200);
        }

        return response()->json(['message' => 'No KTP image found.'], 404);
    }

    // Add a method for admisi to verify user data
    // public function verifyUser(Request $request, $id)
    // {
    //     $request->validate([
    //         'nik' => 'required',
    //         'nama_asli' => 'required',
    //         'tgl_lahir' => 'required',
    //         'alamat' => 'required',
    //         'agama' => 'required',
    //         'perkerjaan' => 'required',
    //     ]);

    //     $pasien = Pasien::find($id);

    //     if (!$pasien) {
    //         return response()->json(['message' => 'Pasien not found.'], 404);
    //     }

    //     $pasien->nik = $request->get('nik');
    //     $pasien->nama_asli = $request->get('nama_asli');
    //     $pasien->tgl_lahir = $request->get('tgl_lahir');
    //     $pasien->alamat = $request->get('alamat');
    //     $pasien->agama = $request->get('agama');
    //     $pasien->perkerjaan = $request->get('perkerjaan');
    //     $pasien->verified = true; // Mark the patient as verified
    //     $pasien->save();

    //     return response()->json(['message' => 'Pasien verified successfully!'], 200);
    // }
}
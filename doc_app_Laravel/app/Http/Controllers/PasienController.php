<?php
namespace App\Http\Controllers;

use App\Models\Pasien;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class PasienController extends Controller {
    public function storeKtp(Request $request)
{
    $request->validate([
        'ktp' => 'image|mimes:jpeg,png,jpg,gif,svg|max:2048',
    ]);

    $user = Auth::user();
    $pasien = Pasien::where('user_id', $user->id)->first();

    if (!$pasien) {
        return response()->json(['message' => 'Pasien record not found.'], 404);
    }

    if ($request->hasFile('ktp')) {
        $image = $request->file('ktp');
        $path = $image->store('ktp_images', 'public');
        $pasien->ktp = $path;
        $pasien->save();

        return response()->json(['message' => 'KTP image uploaded successfully!', 'ktp' => asset('storage/' . $path)], 200);
    }

    return response()->json(['message' => 'No KTP image provided.'], 400);
}


public function showKtp()
{
    $user = Auth::user();
    $pasien = Pasien::where('user_id', $user->id)->first();

    if ($pasien && $pasien->ktp) {
        return response()->json(['ktp' => asset('storage/' . $pasien->ktp)], 200);
    }

    return response()->json(['message' => 'No KTP image found.'], 404);
}


    public function showPasienDetails($userId) {
        $pasien = Pasien::where('user_id', $userId)->with('user')->firstOrFail();
        return response()->json($pasien, 200);
    }
}

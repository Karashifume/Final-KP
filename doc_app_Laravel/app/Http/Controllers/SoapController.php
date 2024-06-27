<?php

namespace App\Http\Controllers;

use App\Models\Soap;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SoapController extends Controller
{
    public function store(Request $request)
    {
        $soap = new Soap();
        $soap->user_id = $request->get('user_id');
        $soap->doc_id = $request->get('doc_id');
        $soap->subjective = $request->get('subjective');
        $soap->objective = $request->get('objective');
        $soap->assessment = $request->get('assessment');
        $soap->planning = $request->get('planning');
        $soap->resep = $request->get('resep');
        $soap->save();

        return response()->json([
            'success' => 'SOAP has been saved successfully!',
        ], 200);
    }

    public function show($id)
    {
        $soap = Soap::where('user_id', $id)->first();

        if ($soap) {
            return response()->json($soap, 200);
        } else {
            return response()->json(['error' => 'SOAP not found'], 404);
        }
    }
}

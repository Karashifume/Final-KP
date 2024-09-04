<?php

namespace App\Http\Controllers;

use App\Models\Soap;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SoapController extends Controller
{
    public function store(Request $request)
    {
        $soap = Soap::updateOrCreate(
            ['appoint_id' => $request->get('appoint_id')],
            [
                'subjective' => $request->get('subjective'),
                'objective' => $request->get('objective'),
                'assessment' => $request->get('assessment'),
                'planning' => $request->get('planning'),
                'resep' => $request->get('resep')
            ]
        );
        return response()->json([
            'success' => 'SOAP has been saved successfully!',
        ], 200);
    }
    public function show($id)
    {
        $soap = Soap::where('appoint_id', $id)->first();
        if ($soap) {
            return response()->json($soap, 200);
        } else {
            return response()->json(['error' => 'SOAP not found'], 404);
        }
    }
}

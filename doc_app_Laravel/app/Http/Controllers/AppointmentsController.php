<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Pasien;
use Illuminate\Support\Facades\Auth;

class AppointmentsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        // Retrieve appointments for the current user
        $user = Auth::user();
        
        if ($user->type == 'doctor') {
            $appointments = Appointments::where('doc_id', $user->id)
            ->whereHas('user.pasien', function($query) {
                $query->where('verified', true);
            })
            ->get();
        } else {
            $appointments = Appointments::where('user_id', $user->id)->get();
        }

        $doctor = User::where('type', 'doctor')->get();
        $pasien = User::where('type', 'user')->get();

        // Add related details to the appointments
        foreach ($appointments as $data) {
            foreach ($doctor as $info) {
                if ($data['doc_id'] == $info['id']) {
                    $data['doctor_name'] = $info['name'];
                    $data['doctor_profile'] = $info['profile_photo_url'];
                    $data['category'] = $info->doctor['category'];
                }
            }
            foreach ($pasien as $info) {
                if ($data['user_id'] == $info['id']) {
                    $data['pasien_name'] = $info['name'];
                    $data['pasien_profile'] = $info['profile_photo_url'];
                }
            }
        }

        return response()->json($appointments);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
{
    $user = Auth::user();

    $appointment = new Appointments();
    $appointment->user_id = $user->id;
    $appointment->doc_id = $request->get('doctor_id');
    $appointment->date = $request->get('date');
    $appointment->day = $request->get('day');
    $appointment->time = $request->get('time');
    $appointment->status = 'upcoming'; 
    $appointment->keluhan = $request->get('keluhan');
    $appointment->alamat = $request->get('alamat');
    $appointment->harga = $request->get('harga'); 
    $appointment->save();

    return response()->json(['success' => 'New Appointment has been made successfully!'], 200);
}
public function updateStatus(Request $request, $id)
    {
        $appointment = Appointments::find($id);
        if ($appointment) {
            $appointment->status = $request->get('status');
            $appointment->save();
            return response()->json(['success' => 'Appointment status updated successfully!'], 200);
        }
        return response()->json(['error' => 'Appointment not found'], 404);
    }
    public function updateDetails(Request $request, $id)
{
    $appointment = Appointments::find($id);
    if ($appointment) {
        $appointment->date = $request->get('date');
        $appointment->day = $request->get('day');
        $appointment->time = $request->get('time');
        $appointment->save();
        return response()->json(['success' => 'Appointment details updated successfully!'], 200);
    }
    return response()->json(['error' => 'Appointment not found'], 404);
}



    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}

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

    public function getDoctorAppointments($doctorId)
{
    $appointments = Appointments::where('doc_id', $doctorId)->where('status', 'upcoming')->get();
    return response()->json($appointments);
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
            $appointment->alasan = $request->get('alasan'); 
            $appointment->save();
            return response()->json(['success' => 'Appointment status updated successfully!'], 200);
        }
        return response()->json(['error' => 'Appointment not found'], 404);
    }

    public function updateAlasan(Request $request, $id)
    {
        $appointment = Appointments::find($id);
        if ($appointment) {
            $appointment->alasan = $request->get('alasan');
            $appointment->save();
            return response()->json(['success' => 'Appointment reason updated successfully!'], 200);
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

}

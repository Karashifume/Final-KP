<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use Illuminate\Http\Request;
use App\Models\User;
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
            $appointments = Appointments::where('doc_id', $user->id)->get();
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
        //this controller is to store booking details post from mobile app
        $appointment = new Appointments();
        $appointment->user_id = Auth::user()->id;
        $appointment->doc_id = $request->get('doctor_id');
        $appointment->date = $request->get('date');
        $appointment->day = $request->get('day');
        $appointment->time = $request->get('time');
        $appointment->status = 'upcoming'; //new appointment will be saved as 'upcoming' by default
        $appointment->keluhan = $request->get('keluhan');
        $appointment->alamat = $request->get('alamat');
        $appointment->harga = 250000; 
        $appointment->save();

        //if successfully, return status code 200
        return response()->json([
            'success'=>'New Appointment has been made successfully!',
        ], 200);

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

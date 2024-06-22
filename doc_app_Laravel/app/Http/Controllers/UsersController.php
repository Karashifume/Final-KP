<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\User;
use App\Models\Doctor;
use App\Models\Pasien;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = array(); // This will return a set of user and doctor data
        $user = Auth::user();
        $doctor = User::where('type', 'doctor')->get();
        $details = $user->pasien;
        $doctorData = Doctor::all();
        // This is the date format without leading zeros
        $date = now()->format('n/j/Y'); // Change date format to suit the format in database

        // Make this appointment filter only status is "upcoming"
        $appointment = Appointments::where('status', 'upcoming')->where('date', $date)->first();

        // Collect user data and all doctor details
        foreach ($doctorData as $data) {
            // Sorting doctor name and doctor details
            foreach ($doctor as $info) {
                if ($data['doc_id'] == $info['id']) {
                    $data['doctor_name'] = $info['name'];
                    $data['doctor_profile'] = $info['profile_photo_url'];
                    if (isset($appointment) && $appointment['doc_id'] == $info['id']) {
                        $data['appointments'] = $appointment;
                    }
                }
            }
        }

        $user['doctor'] = $doctorData;
        $user['details'] = $details; // Return user details here together with doctor list

        return $user; // Return all data
    }

    /**
     * Login.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function login(Request $request)
    {
        // Validate incoming inputs
        Log::info('Login method called', $request->all());
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // Check matching user
        $user = User::where('email', $request->email)->first();

        // Check password
        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect'],
            ]);
        }

        // Then return generated token
        return $user->createToken($request->email)->plainTextToken;
    }

    /**
     * Register.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        // Validate incoming inputs
        $request->validate([
            'name' => 'required|string',
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'type' => 'user',
            'password' => Hash::make($request->password),
        ]);

        $userInfo = Pasien::create([
            'user_id' => $user->id,
            'status' => 'active',
        ]);

        return $user;
    }

    /**
     * Update favorite doctor list.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function storeFavDoc(Request $request)
    {
        $saveFav = Pasien::where('user_id', Auth::user()->id)->first();

        $docList = json_encode($request->get('favList'));

        // Update fav list into database
        $saveFav->fav = $docList; // And remember to update this as well
        $saveFav->save();

        return response()->json([
            'success' => 'The Favorite List is updated',
        ], 200);
    }

    /**
     * Logout.
     *
     * @return \Illuminate\Http\Response
     */
    public function logout()
    {
        $user = Auth::user();
        //$user->currentAccessToken()->delete();

        return response()->json([
            'success' => 'Logout successfully!',
        ], 200);
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
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param int $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param int $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param \Illuminate\Http\Request $request
     * @param int $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param int $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}

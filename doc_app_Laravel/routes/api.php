<?php

use App\Http\Controllers\AppointmentsController;
use App\Http\Controllers\DocsController;
use App\Http\Controllers\PasienController;
use App\Http\Controllers\UsersController;
use App\Http\Controllers\SoapController;
use App\Http\Controllers\AdmisiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

//this is the endpoint with prefix /api
Route::post('/login', [UsersController::class, 'login']);
Route::post('/register', [UsersController::class, 'register']);

//modify this
//this group mean return user's data if authenticated successfully
Route::middleware('auth:sanctum')->group(function() {
    Route::get('/user', [UsersController::class, 'index']);
    Route::post('/fav', [UsersController::class, 'storeFavDoc']);
    Route::post('/logout', [UsersController::class, 'logout']);
    Route::post('/ktp', [PasienController::class, 'storeKtp']);
    Route::get('/ktp', [PasienController::class, 'showKtp']);
    Route::get('/pasien/details/{user_id}', [PasienController::class, 'showPasienDetails']);
    Route::post('/book', [AppointmentsController::class, 'store']);
    Route::post('/reviews', [DocsController::class, 'store']);
    Route::get('/appointments', [AppointmentsController::class, 'index']);
    Route::get('/profile', [DocsController::class, 'index'])->name('profile');
    Route::post('/profile/update', [DocsController::class, 'updateProfile'])->name('profile.update');
    Route::post('/soap', [SoapController::class, 'store']);
    Route::get('/soap/{id}', [SoapController::class, 'show']);
    Route::get('/admisi/unverified', [AdmisiController::class, 'getUnverifiedUsers']);
    Route::post('/admisi/verify', [AdmisiController::class, 'verifyUser']);
    Route::put('/appointments/{id}/status', [AppointmentsController::class, 'updateStatus']);
    Route::put('/appointments/{id}/details', [AppointmentsController::class, 'updateDetails']);
});
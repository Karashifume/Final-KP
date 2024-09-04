<?php

namespace App\Actions\Fortify;

use App\Models\User;
use App\Models\Doctor;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Laravel\Fortify\Contracts\CreatesNewUsers;

class CreateNewUser implements CreatesNewUsers
{
    use PasswordValidationRules;

    /**
     * Validate and create a newly registered user.
     *
     * @param  array<string, string>  $input
     */
    public function create(array $input): User
    {
        Validator::make($input, [
            'name' => ['required', 'string', 'max:255'],
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                Rule::unique(User::class),
            ],
            'password' => $this->passwordRules(),
        ])->validate();

        $user = User::create([
            'name' => $input['name'],
            'email' => $input['email'],
            'type' => 'doctor',
            'password' => Hash::make($input['password']),
        ]);
        if ($user->type === 'doctor') {
            Doctor::create([
                'doc_id' => $user->id, // Assuming 'doc_id' should match the user's id
                // You may want to provide defaults or additional inputs for these fields
            ]);
        }

        return $user;
    }
}

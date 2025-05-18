<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class BranchRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'address' => 'required|string',
            'latitude' => 'required|numeric|between:-90,90',
            'longitude' => 'required|numeric|between:-180,180',
            'contact_number' => 'required|string|max:20',
            'opening_hours' => 'required|array',
            'opening_hours.*.day' => 'required|string',
            'opening_hours.*.open' => 'required|string',
            'opening_hours.*.close' => 'required|string',
            'delivery_radius' => 'required|numeric|min:0',
            'is_active' => 'boolean',
        ];
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\Branch;
use Inertia\Inertia;
use Illuminate\Http\Request;

class BranchSelectionController extends Controller
{
    public function index(Request $request)
    {
        $userLat = $request->input('latitude');
        $userLng = $request->input('longitude');

        $query = Branch::query()->active();

        if ($userLat && $userLng) {
            $query->withDistance($userLat, $userLng)
                  ->orderBy('distance');
        } else {
            $query->orderBy('name');
        }

        $branches = $query->get();

        return Inertia::render('Customer/BranchSelection', [
            'branches' => $branches,
            'userLocation' => [
                'latitude' => $userLat ? (float)$userLat : null,
                'longitude' => $userLng ? (float)$userLng : null
            ]
        ]);
    }
}

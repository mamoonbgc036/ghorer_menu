<?php

namespace App\Http\Controllers;

use App\Models\Food;
use Inertia\Inertia;
use App\Models\Branch;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class FoodMenuController extends Controller
{
    public function index(Request $request, Branch $branch)
    {
            $foods = DB::table('food')
                    ->join('categories', 'food.category_id', '=', 'categories.id')
                    ->leftJoin('extra_options', 'food.id', '=', 'extra_options.food_id')
                    ->select(
                        'food.*',
                        'categories.name as category_name',
                        DB::raw('GROUP_CONCAT(extra_options.name) as extra_option_names')
                    )
                    ->where('food.branch_id', $branch->id)
                    ->where('food.is_available', true)
                    ->orderBy('food.sort_order')
                    ->groupBy('food.id', 'categories.name') 
                    ->get()
                    ->groupBy('category_id');

        $categories = Category::whereHas('foods', function ($query) use ($branch) {
            $query->where('branch_id', $branch->id)
                ->where('is_available', true);
        })->get();



        return Inertia::render('Customer/FoodMenu', [
            'branch' => $branch,
            'categories' => $categories,
            'foods' => $foods,
            'orderType' => $request->input('type', 'collection') // collection or delivery
        ]);
    }
}

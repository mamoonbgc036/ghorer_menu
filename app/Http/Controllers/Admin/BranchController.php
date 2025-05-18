<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Branch;
use App\Http\Requests\BranchRequest;
use Inertia\Inertia;

class BranchController extends Controller
{
    public function index()
    {
        $branches = Branch::query()
            ->withCount('foods')
            ->orderBy('name')
            ->paginate(10);

        return Inertia::render('Admin/Branches/Index', [
            'branches' => [
                'data' => $branches->items(),
                'meta' => [
                    'current_page' => $branches->currentPage(),
                    'from' => $branches->firstItem(),
                    'last_page' => $branches->lastPage(),
                    'links' => $branches->linkCollection()->toArray(),
                    'path' => $branches->path(),
                    'per_page' => $branches->perPage(),
                    'to' => $branches->lastItem(),
                    'total' => $branches->total(),
                ],
            ],
            'flash' => [
                'success' => session('success'),
                'error' => session('error')
            ],
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Branches/Form');
    }

    public function store(BranchRequest $request)
    {
        try {
            Branch::create($request->validated());
            return redirect()->route('admin.branches.index')
                ->with('success', 'Branch created successfully.');
        } catch (\Exception $e) {
            return back()->with('error', 'Error creating branch. Please try again.');
        }
    }

    public function edit(Branch $branch)
    {
        return Inertia::render('Admin/Branches/Form', [
            'branch' => $branch
        ]);
    }

    public function update(BranchRequest $request, Branch $branch)
    {
        try {
            $branch->update($request->validated());
            return redirect()->route('admin.branches.index')
                ->with('success', 'Branch updated successfully.');
        } catch (\Exception $e) {
            return back()->with('error', 'Error updating branch. Please try again.');
        }
    }

    public function destroy(Branch $branch)
    {
        try {
            if ($branch->foods()->exists()) {
                return back()->with('error', 'Cannot delete branch with associated foods.');
            }

            $branch->delete();
            return back()->with('success', 'Branch deleted successfully.');
        } catch (\Exception $e) {
            return back()->with('error', 'Error deleting branch. Please try again.');
        }
    }
}

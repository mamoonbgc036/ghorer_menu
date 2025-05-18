<?php

use App\Http\Controllers\Admin\AdminOrderController;
use App\Http\Controllers\Admin\BranchController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\FoodController;
use App\Http\Controllers\BranchSelectionController;
use App\Http\Controllers\CheckoutController;
use App\Http\Controllers\CustomerOrderController;
use App\Http\Controllers\FoodMenuController;
use App\Http\Controllers\ProfileController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/welcome', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/', function () {
    return Inertia::render('Home');
})->name('home');



Route::middleware(['auth', 'not-customer'])->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});


Route::middleware(['auth', 'not-customer'])->prefix('admin')->name('admin.')->group(function () {
    Route::resource('categories', CategoryController::class);
    Route::post('categories/update-order', [CategoryController::class, 'updateOrder'])
        ->name('categories.update-order');
    Route::resource('branches', BranchController::class);
    Route::resource('foods', FoodController::class);
    Route::get('/dashboard', function () {
        return Inertia::render('Dashboard');
    })->name('dashboard');
    Route::get('orders', [AdminOrderController::class, 'index'])->name('orders.index');
    Route::get('orders/{order}', [AdminOrderController::class, 'show'])->name('orders.show');
    Route::patch('orders/{order}/status', [AdminOrderController::class, 'updateStatus'])->name('orders.update-status');
});


Route::get('/locations', [BranchSelectionController::class, 'index'])
    ->name('customer.locations');
Route::get('/branch/{branch}/menu', [FoodMenuController::class, 'index'])
    ->name('customer.branch.menu');

Route::middleware(['auth'])->group(function () {

    Route::get('/checkout/{branch}', [CheckoutController::class, 'checkout'])
        ->name('customer.checkout');
    Route::post('/orders', [CheckoutController::class, 'store'])->name('customer.orders.store');
    Route::post('/addresses', [CheckoutController::class, 'storeAddress'])
        ->name('customer.addresses.store');
    Route::put('/addresses/{address}', [CheckoutController::class, 'updateAddress'])
        ->name('customer.addresses.update');
    Route::delete('/addresses/{address}', [CheckoutController::class, 'deleteAddress'])
        ->name('customer.addresses.delete');
    Route::post('/addresses/{address}/default', [CheckoutController::class, 'setDefaultAddress'])
        ->name('customer.addresses.setDefault');


    Route::prefix('customer')->name('customer.')->group(function () {
        Route::get('/orders', [CustomerOrderController::class, 'index'])->name('orders.index');
        Route::get('/orders/{order}', [CustomerOrderController::class, 'show'])->name('orders.show');
    });
});

require __DIR__ . '/auth.php';

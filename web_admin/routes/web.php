<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return "Gada apa-apa disini";
});


Route::post('/login', 'AdminController@login');
Route::prefix('/admin')->name('admin.')->group(function(){
    Route::get('/login', 'AdminController@showLoginForm')->name('login');//->middleware('auth:admin');
    Route::post('/login', 'AdminController@login');
    Route::get('/logout', 'AdminController@logout')->name('logout');

    Route::get('/', 'AdminController@dashboard')->middleware('auth:admin');
    Route::get('/dashboard', 'AdminController@dashboard')->name('home')->middleware('auth:admin');
    Route::post('/dashboard', 'AdminController@aksi')->name('home')->middleware('auth:admin');
});

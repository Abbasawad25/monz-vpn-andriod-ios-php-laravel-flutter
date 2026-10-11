<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::get('/', function () {
    return "Mau ngapain :(, jangan diacak acak dong";
});
Route::group(['prefix' => 'allserver'], function () {
    Route::get('/', "api\VPNController@allVPNServer");
    Route::get('/free', "api\VPNController@allVPNFreeServer");
    Route::get('/pro', "api\VPNController@allVPNProServer");
});


Route::get('/detail/{id}', "api\VPNController@detailVpn");
Route::get('/detail/random', "api\VPNController@randomVpn");

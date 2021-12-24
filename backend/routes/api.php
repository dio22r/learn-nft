<?php

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

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('nftmeta/', function () {
    $jsonString = file_get_contents(base_path('storage/app/json/nft-data.json'));
    $data = json_decode($jsonString, true);

    return $data;
});

Route::get('nftmeta/{tokenid}', function (String $tokenid) {
    $jsonString = file_get_contents(base_path('storage/app/json/nft-data.json'));
    $data = json_decode($jsonString, true);

    if (!isset($data[$tokenid])) {
        abort(404);
    }

    return $data[$tokenid];
});

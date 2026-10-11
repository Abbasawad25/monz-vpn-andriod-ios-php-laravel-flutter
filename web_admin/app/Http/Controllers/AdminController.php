<?php

namespace App\Http\Controllers;

use App\VPNServer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class AdminController extends Controller
{
    function index()
    {
        return redirect()->route('admin.home');
    }
    function showLoginForm()
    {
        if (Auth::guard("admin")->check()) {
            return redirect(route("admin.home"));
        }

        return view("login");
    }

    public function login(Request $request)
    {

        $rules = [
            'email'    => 'required|email|exists:admins|min:5|max:191',
            'password' => 'required|string|min:4|max:255',
            'key' => 'required|string|min:8|max:256',
        ];

        $messages = ['email.exists' => 'Email tidak ditemukan!'];

        $validate = Validator::make($request->all(), $rules, $messages);


        if ($validate->fails()) {
            return redirect()->route("admin.login")
                ->with(["error" => $validate->errors()->toArray()]);
        }

        if (Auth::guard('admin')->attempt([
            "email" => $request->input("email"),
            "password" => $request->input("password"),
            "key" => $request->input("key")
        ], $request->input('remember'))) {
            return redirect(route("admin.home"))
                ->with('status', 'Masuk dong!');
        }

        return redirect()->route("admin.login")
            ->with(["error" => ["key" => ["Login kaga valid, isi yang bener lah!"]]]);
    }


    function logout()
    {
        Auth::guard('admin')->logout();
        return redirect()->route("admin.login")
            ->with('status', 'Logout!');
    }

    function dashboard()
    {
        return view("dashboard", ["data_vpn" => VPNServer::orderBy("status")->get()]);
    }

    function aksi(Request $request)
    {
        switch (strtolower($request->input("submit"))) {
            case "hapus":
                VPNServer::where(["id" => $request->input("id")])->get()->first()->delete();
                break;
            case "tambah":
                VPNServer::insert([
                    "name" => $request->input("name"),
                    "flag" => $request->input("bendera"),
                    "slug" => Str::random(64),
                    "config" => $request->input("config"),
                    "username" => $request->input("username"),
                    "status" => (int) $request->input("status"),
                    "password" => $request->input("password"),
                ]);
                break;
        }
        return redirect()->back();
    }
}

<?php

namespace App\Http\Controllers\api;
use App\Http\Controllers\Controller;
use App\VPNServer;

class VPNController extends Controller
{
    function allVPNServer()
    {
        return $this->printJson("Berhasil mendapatkan server vpn", true,  VPNServer::orderBy("status")->get());
    }
    function allVPNFreeServer()
    {
        return $this->printJson("Berhasil mendapatkan free server vpn", true,  VPNServer::where("status", 0)->get());
    }
    function allVPNProServer()
    {
        return $this->printJson("Berhasil mendapatkan pro server vpn", true,  VPNServer::where("status", 1)->get());
    }

    function detailVpn($id)
    {
        $vpnServer = VPNServer::where("slug", $id)->get()->first();
        if ($vpnServer == null) return $this->printJson("VPN tidak valid");
        $result = $vpnServer->toArray();
        $result["username"] = $vpnServer->username;
        $result["password"] = $vpnServer->password;
        $result["config"] = $vpnServer->config;


        return $this->printJson("Berhasil mendapatkan detail VPN", true,  $result);
    }

    function randomVpn()
    {
        $vpnServer = VPNServer::all()->random();
        if ($vpnServer == null) return $this->printJson("Tidak ada vpn untuk ditampilkan");
        $result = $vpnServer->toArray();
        $result["username"] = $vpnServer->username;
        $result["password"] = $vpnServer->password;
        $result["config"] = $vpnServer->config;
        return $this->printJson("Berhasil mendapatkan random VPN", true,  $result);
    }
}

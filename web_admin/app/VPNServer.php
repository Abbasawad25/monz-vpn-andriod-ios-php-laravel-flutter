<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class VPNServer extends Model
{
    protected $table = "vpnserver";
    protected $hidden = ["config","username","password","status"];
    protected $fillable = ["name","config","flag", "slug","username","password","status"];
}

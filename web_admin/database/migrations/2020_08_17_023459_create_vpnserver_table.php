<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVpnserverTable extends Migration
{
    public function up()
    {
        Schema::create('vpnserver', function (Blueprint $table) {
            $table->id();
            $table->string("name")->nullable(false);
            $table->string("flag")->nullable(false);
            $table->longText("config")->nullable(false);
            $table->longText("slug")->nullable(false);
            $table->string("username")->nullable();
            $table->string("password")->nullable();
            $table->tinyInteger("status")->default(0);
        });
    }
    public function down()
    {
        Schema::dropIfExists('vpnserver');
    }
}

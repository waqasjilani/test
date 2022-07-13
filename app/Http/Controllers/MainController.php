<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;

class MainController extends Controller
{
	public function testRequest() {
		$client = new \GuzzleHttp\Client();
		$response = $client->get(config('app.dummy_two_endpoint') . '/test/response', ['verify' => false])->getBody()->getContents();

		return response()->json([
			'response_from_dummy_app_two' => $response,
            'update' => true,
		]);
	}
	
	public function testResponse() {
		return response()->json([
			'application' => 'one',
			'data' => rand(100,999),
			'test' => 1
		]);
	}
}

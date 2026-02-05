extends Node

var _http_request:HTTPRequest

var _api_url:String = "http://localhost:8080"

var _message_stack = []

var _requesting = false

func _ready():
	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.request_completed.connect(_on_request_completed)
	
	
	log_information("App Started")
	log_warnining("Test warninig")
	log_error("Test error")
	log_client_data("Test data")


func _physics_process(delta: float) -> void:
	if(!_requesting):
		if(_message_stack.size() > 0):
			var dat = _message_stack.pop_front()
			if(dat.has("path")  && dat.has("client_id") && dat.has("message")):
				var status = _http_request.request(_api_url+"/" + dat["path"], ["Content-Type: application/json"], HTTPClient.METHOD_POST, JSON.stringify(dat))
				_requesting = true

func log_information(message:String):
	var json = {
		"client_id": get_unique_machine_id(),
		"message": message,
		"path":"logInfo"
	}
	_message_stack.append(json)

func log_warnining(message:String):
	var json = {
			"client_id": get_unique_machine_id(),
			"message": message,
			"path":"logWarning"
		}
	_message_stack.append(json)

func log_error(message:String):
	var json = {
			"client_id": get_unique_machine_id(),
			"message": message,
			"path": "logError"
		}
	_message_stack.append(json)

func log_client_data(message:String):
	var json = {
			"client_id": get_unique_machine_id(),
			"message": message,
			"path": "logClientData"
		}
	_message_stack.append(json)



func get_unique_machine_id():
	return OS.get_unique_id().replace("{", "").replace("}", "")

func set_api_url(path:String):
	_api_url = _api_url


func _on_request_completed(result, response_code, headers, body):
	print(response_code)
	_requesting = false

extends Node

var http
var query: String = "Test query"
var temperature: float = 0.9
# min-value 0.0
# max-value 1.0
# 0.5 is the standard value. Increase it to get a more random answer

var max_tokens: int = 1024 # max lenght of the answer
var url = ""
var api_key = ""
var headers = ["Content-Type: application/json", "Authorization: Bearer " + api_key]
var engine = "text-davinci-003"

func send_query_to_chatgpt() -> void:
	http = HTTPRequest.new()
	self.add_child(http)
	http.connect("request_completed", self, "http_request_completed")

	var body = JSON.print({
		"prompt": query,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": engine
	})
	var error = http.request(url, headers, true, HTTPClient.METHOD_POST, body)
	print ("error code ", error)


func http_request_completed(result, response_code, headers, body) -> void:
	print("http request completed.\n")
	var response = parse_json(body.get_string_from_utf8())
	print(response)
	var curated_text: String = ""
	for i in range(0, response.choices.size()):
		curated_text += response.choices[i].text + "\n"
	print(curated_text)
	http.queue_free()

def last_json
  @last_json ||= MultiJson.decode(last_response.body)
end

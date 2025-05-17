your/path/to/ruby <<'EOF'
require 'net/http'
require 'json'
require 'uri'

API_KEY = ENV["OPENAI_API_KEY"]

def translate(text)
  target_lang = text.match?(/[ぁ-んァ-ン一-龥]/) ? 'English' : 'Japanese'

  prompt = <<~PROMPT
    Translate the following text to #{target_lang}.
    Output in the following format:

    <入力文>
    ---
    <出力文>

    Text:
    #{text}
  PROMPT

  uri = URI("https://api.openai.com/v1/chat/completions")

  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{API_KEY}"
  }

  body = {
    model: "gpt-4o",
    messages: [
      { role: "user", content: prompt }
    ],
    temperature: 0.2
  }.to_json

  response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    req = Net::HTTP::Post.new(uri.path, headers)
    req.body = body
    http.request(req)
  end

  result = JSON.parse(response.body)

  if result["choices"] && result["choices"][0]["message"]
    translated_text = result["choices"][0]["message"]["content"]
    puts translated_text.strip
  else
    puts "Error: #{result}"
  end
end

translate("{query}")
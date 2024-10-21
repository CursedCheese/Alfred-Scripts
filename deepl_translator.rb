your/path/to/ruby <<'EOF'
require 'rest-client'
require 'json'

API_KEY = ENV["DEEPL_API_KEY"]

def translate(text)
  url = 'https://api-free.deepl.com/v2/translate'

  target_lang = text.match?(/[ぁ-んァ-ン一-龥]/) ? 'EN' : 'JA'

  response = RestClient.post(url, {
    auth_key: API_KEY,
    text: text,
    target_lang: target_lang
  })

  result = JSON.parse(response.body)
  translated_text = result['translations'][0]['text']
  puts translated_text
end

def detect_target_language(text)
  url = 'https://api-free.deepl.com/v2/translate'
  response = RestClient.post(url, {
    auth_key: API_KEY,
    text: text,
    target_lang: 'EN'
  })
  detected_language = JSON.parse(response.body)['translations'][0]['detected_source_language']

  if detected_language == 'EN'
    'JA'
  else
    'EN'
  end
end

translate("{query}")
EOF
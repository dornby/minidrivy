require_relative "secrets"
require "faraday"

response = Faraday.get 'https://api.trello.com/1/boards/LFZoaH46/cards?fields=name,url'

json_cards = response.body

require "json"

cards = JSON.parse(json_cards)

infos = []

cards.each do |card|
  infos += [card["id"] + ": " + card["name"]]
end

if ARGV[0] == "list"
  puts infos
elsif ARGV[0] == "create"
  Faraday.post('https://api.trello.com/1/cards', { :name => ARGV[1],
  :key => API_KEY_TRELLO,
  :token => TOKEN_TRELLO })
elsif ARGV[0] == "delete" and Faraday.delete('https://api.trello.com/1/cards/' + ARGV[1], {:key => API_KEY_TRELLO,
:token => TOKEN_TRELLO }).status.between?(200, 299) == true
  Faraday.delete('https://api.trello.com/1/cards/' + ARGV[1], {:key => API_KEY_TRELLO,
  :token => TOKEN_TRELLO })
elsif ARGV[0] == "delete" and Faraday.delete('https://api.trello.com/1/cards/' + ARGV[1], {:key => API_KEY_TRELLO,
:token => TOKEN_TRELLO }).status.between?(200, 299) == false
  puts "We couldn't find any card with the id "+ ARGV[1] + "\n Here is the list of existing cards:\n"
else
  puts "error"
end

# Made-up clients for trying the app locally. Never put real client details here:
# this repo is public.

return if Client.exists?

juniper = Client.create!(name: "Maya Example", email: "maya@example.com", company: "Juniper Cafe")
river = Client.create!(name: "Sam Sample", email: "sam@example.com", company: "Riverbend Yoga")

menu = Quote.create!(client: juniper, title: "Menu and signage refresh")
menu.line_items.create!(description: "Discovery call and moodboard", quantity: 1, unit_price: "250")
menu.line_items.create!(description: "Menu layout, two rounds of edits", quantity: 2, unit_price: "300")
menu.line_items.create!(description: "Window signage", quantity: 3, unit_price: "85")
menu.send_to_client!

site = Quote.create!(client: river, title: "Website and booking page")
site.line_items.create!(description: "Five-page website", quantity: 1, unit_price: "1800")
site.line_items.create!(description: "Class booking setup", quantity: 6, unit_price: "75")
site.send_to_client!
site.accept!(name: "Sam Sample")

Quote.create!(client: river, title: "Spring workshop poster")

puts "Seeded #{Client.count} clients and #{Quote.count} quotes."

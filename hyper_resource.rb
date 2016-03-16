require 'hyperresource'

def print_response(res)
  # puts "http code: #{res.response.status}"
  puts "message:" + res.message if res.attributes.include? "message"
  puts "errors:" + res.errors.to_s if res.attributes.include? "errors"
  puts "id :" + res.id.to_s if res.attributes.include? "id"
  puts ""
end
puts "Starting"
timestamp  = Time.now.to_i
headers = {"Accept"=>"application/json", :"Content-type"=>"application/json"}
api = HyperResource.new(root: ARGV.first || 'http://localhost:9292',  headers: headers)

puts "Creating Session"

res = api.sign_up.post({user:{email:"123"}})
puts "Invalid Arguments should not create"
print_response(res)


res = api.sign_up.post({user:{email:"email_#{timestamp}@example.com", password: "123456789"}})
api.headers = headers.merge({"access_token": res.access_token})
puts "Valid arguments should create"
print_response(res)


puts "should fail with same email"
res = api.sign_up.post({user:{email:"email_#{timestamp}@example.com", password: "123456789"}})
print_response(res)

puts "Get existing Lists"

res = api.lists.get
puts "count:" + res.count.to_s
print_response(res)

if !api.lists.body.empty? && api.lists.body['_links'].keys.include?("next")
  puts "Get next List"

  res = api.lists.last_page.next
  puts "count:" + res.count.to_s
  print_response(res)
end

puts "next page count: #{res.body.count}"
puts "empty code shoud be 204: #{res.response.status}" if res.body.count == 0

puts "Create List"

list = api.lists.post({list: {name: "list", items_attributes: [{name: "item1"},{name: "item2", tags_attributes:[{name: "tag"}]}]}})
print_response(list)

puts "items should be 2: #{list.items.count}"
puts "last item should have 1 tag: #{list.items.last.tags.count}"
puts "tag name should be tag: #{list.items.last.tags.first.name}"

puts "Update List"
list = list.put({list: {name: "rename_list"}})
puts "list new name should be rename_list: #{list.name}"

puts "Create new Tag and new Item"
puts "Should fail without item_id"
res = api.items.post({item: {name: "new_item", tags_attributes:[{name: "tag"}]}})
print_response(res)

puts "Should work with item_id"
item = api.items.post({item: {name: "new_item", list_id: list.id, tags_attributes:[{name: "tag"}]}})
print_response(item)
puts "item should have 1 tag: #{item.tags.count}"

puts "should add more tags"

tag1 = api.tags.post({tag: {name: "another_tag"}})
tag2 = api.tags.post({tag: {name: "another_tag"}})
puts "before update tags: #{item.tags.count}"
item = item.put({item: {name: "new_name", tag_ids:[tag1.id, tag2.id] }})
print_response(item)
puts "after update tags: #{item.tags.count}"

puts "Should work without item_id"
tag = api.tags.post({tag: {name: "new_tag"}})
print_response(tag)

puts "Should work with item_id"
res = api.tags.post({tag: {name: "new_tag", item_ids:[item.id] }})
print_response(res)

puts "should remove objects"
print_response(list.delete())
print_response(item.delete())
print_response(tag.delete())

puts "should logout user"

print_response(api.logout.delete)
begin
  puts "Trying to use access_token"
  res = api.lists.get
rescue HyperResource::ClientError => status
  puts "unauthenticated error: #{status}"
end

puts "Login again"
res = api.sign_in.put({user:{email:"email_#{timestamp}@example.com", password: "123456789"}})
print_response(res)

access_token = res.access_token
api.headers = headers.merge({"access_token": access_token})

res = api.lists.get
puts "list count:" + res.count.to_s

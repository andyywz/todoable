RSpec.describe Todoable do
  describe Todoable::ListHelper do
    let (:username)  { 'andyywz@gmail.com' }
    let (:password)  { 'todoable' }
    let (:list_url)  { 'http://todoable.teachable.tech/api/lists' }
    let (:list_id)   { 'some-list-id' }
    let (:item_id)   { 'some-item-id' }
    let (:item_name) { 'test item name' }
    let (:fake_list) {
      OpenStruct.new(
        body: {
          name: item_name,
          src: 'fake src',
          id: item_id
        }.to_json
      )
    }
    let (:session) {
      VCR.use_cassette('list_helper') do
        Todoable::Session.new(username, password)
      end
    }

    describe 'description' do

    end
  end
end

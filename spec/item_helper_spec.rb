RSpec.describe Todoable do
  describe Todoable::ItemHelper do
    let (:username)  { 'andyywz@gmail.com' }
    let (:password)  { 'todoable' }
    let (:list_url)  { 'http://todoable.teachable.tech/api/lists' }
    let (:list_id)   { 'some-list-id' }
    let (:item_id)   { 'some-item-id' }
    let (:item_name) { 'test item name' }
    let (:fake_item) {
      OpenStruct.new(
        body: {
          name: item_name,
          src: 'fake src',
          id: item_id
        }.to_json
      )
    }
    let (:session) {
      VCR.use_cassette('item_helper') do
        Todoable::Session.new(username, password)
      end
    }

    describe '.create_item' do
      it 'returns item attributes' do
        allow_any_instance_of(Todoable::Session).to receive(:invoke)
          .with(:post, "#{list_url}/#{list_id}/items", { item: { name: item_name } })
          .and_return(fake_item)

        response = session.create_item(list_id, item_name)
        expect(response).to eq(JSON.parse(fake_item.body))
      end
    end

    describe '.complete' do
      it 'returns a confirmation string' do
        message = 'some confirmation message'
        allow_any_instance_of(Todoable::Session).to receive(:invoke)
          .with(:put, "#{list_url}/#{list_id}/items/#{item_id}/finish")
          .and_return(message)

        response = session.complete(list_id, item_id)
        expect(response).to eq(message)
      end
    end

    describe '.delete_item' do
      it 'returns an empty string' do
        allow_any_instance_of(Todoable::Session).to receive(:invoke)
          .with(:delete, "#{list_url}/#{list_id}/items/#{item_id}")
          .and_return('')

        response = session.delete_item(list_id, item_id)
        expect(response).to eq('')
      end
    end
  end
end

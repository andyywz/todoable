require 'stub_api_helper'

RSpec.describe Todoable do
  describe Todoable::ItemHelper do
    let (:session) { Todoable::Session.new('fakeuser', 'fakepass') }

    let (:list_url)  { 'http://todoable.teachable.tech/api/lists' }
    let (:list_id)   { 'some-list-id' }
    let (:item_id)   { 'some-item-id' }
    let (:item_name) { 'test item name' }
    let (:fake_item) {
      {
        name: item_name,
        src: 'fake src',
        id: item_id
      }.to_json
    }

    before(:each) do
      session.token = 'fake-token'
      session.token_expiry = Time.now + 1000
    end

    describe '#create_item' do
      it 'returns item attributes' do
        payload = { item: { name: item_name } }
        stub_payload_api(:post, "#{list_url}/#{list_id}/items", payload, fake_item)

        response = session.create_item(list_id, item_name)
        expect(response).to eq(JSON.parse(fake_item))
      end
    end

    describe '#mark_complete' do
      it 'returns a confirmation string' do
        message = 'some confirmation message'
        stub_api(:put, "#{list_url}/#{list_id}/items/#{item_id}/finish", message)

        response = session.mark_complete(list_id, item_id)
        expect(response).to eq(message)
      end
    end

    describe '#delete_item' do
      it 'returns an empty string' do
        stub_api(:delete, "#{list_url}/#{list_id}/items/#{item_id}", '')

        response = session.delete_item(list_id, item_id)
        expect(response).to eq('')
      end
    end
  end
end

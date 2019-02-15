require 'stub_api_helper'

RSpec.describe Todoable do
  describe Todoable::ListHelper do
    let (:session) { Todoable::Session.new('fakeuser', 'fakepass') }

    let (:list_url)  { 'http://todoable.teachable.tech/api/lists' }
    let (:list_id)   { 'some-list-id' }
    let (:list_name) { 'test list name' }
    let (:fake_list) {
      {
        'name' => list_name,
        'src' => 'fake src',
        'id' => list_id
      }
    }

    describe '#lists' do
      it 'returns an array of list attributes' do
        lists_response = {
          lists: [
            fake_list
          ]
        }.to_json

        stub_api(:get, list_url, lists_response)

        response = session.lists
        expect(response).to eq([ fake_list ])
      end
    end

    describe '#get_list' do
      it 'returns list attributes' do
        stub_api(:get, "#{list_url}/#{list_id}", fake_list.to_json)

        response = session.get_list(list_id)
        expect(response).to eq(fake_list)
      end
    end

    describe '#create_list' do
      it 'returns list attributes' do
        payload = { list: { name: list_name } }
        stub_payload_api(:post, list_url, payload, fake_list.to_json)

        response = session.create_list(list_name)
        expect(response).to eq(fake_list)
      end
    end

    describe '#update_list_name' do
      it 'returns the updated list name' do
        new_name = 'new list name'
        payload = { list: { name: new_name } }
        stub_payload_api(:patch, "#{list_url}/#{list_id}", payload, new_name)

        response = session.update_list_name(list_id, new_name)
        expect(response).to eq(new_name)
      end
    end

    describe '#delete_list' do
      it 'returns an empty string' do
        stub_api(:delete, "#{list_url}/#{list_id}", '')

        response = session.delete_list(list_id)
        expect(response).to eq('')
      end
    end
  end
end

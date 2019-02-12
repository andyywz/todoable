RSpec.describe Todoable do
  it 'has a version number' do
    expect(Todoable::VERSION).not_to be nil
  end

  describe 'when creating a new session' do
    before(:all) do
      @session = Todoable::Session.new('test', 'password')
    end

    it 'creates a Todoable::Session' do
      expect(@session).to be_an_instance_of(Todoable::Session)
    end

    it 'authenticates the user' do
      expect_any_instance_of(Todoable::Session).to receive(:authenticate)
      Todoable::Session.new('test', 'test')
    end

    describe '.authenticate' do
      xit 'gets the authentication token' do
      end

      it 'returns a token' do
        token = @session.authenticate
        expect(token).to eq({ 'token': 'fake-token' })
      end
    end
  end
end

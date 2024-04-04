require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user, name: 'John Doe', username: 'johndoe', email: 'johndoe@example.com') }

  subject { described_class.new(user) }

  it 'serializes the user attributes' do
    expected_json = {
      'id' => user.id,
      'name' => 'John Doe',
      'username' => 'johndoe',
      'email' => 'johndoe@example.com'
    }.to_json

    expect(JSON.parse(subject.to_json)).to eq(JSON.parse(expected_json))
  end
end

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "GET /users" do
    it "returns a list of users" do
      user = create_list(:user, 3)

      token = generate_jwt_token(User.first)
      headers = { 'Authorization' => token }

      get "/users", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /users/:username' do
    it 'returns a user' do
      user = create(:user)
      token = generate_jwt_token(user)
      headers = { 'Authorization' => token }

      get "/users/#{user.username}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['username']).to eq(user.username)
    end
  end

  describe 'POST /users' do
    it 'creates a new user' do
      user_params = attributes_for(:user)

      post '/users', params: { user: user_params }
      expect(response).to have_http_status(:created)
      expect(User.last.name).to eq(user_params[:name])
    end
  end

  describe 'PATCH /users/:username' do
    it 'updates an existing user' do
      user = create(:user)
      updated_name = 'Updated Name'
      token = generate_jwt_token(user)
      headers = { 'Authorization' => token }

      patch "/users/#{user.username}", params: { user: { name: updated_name } }, headers: headers

      expect(response).to have_http_status(:no_content)
      expect(User.find_by(username: user.username).name).to eq(updated_name)
    end
  end

  describe 'DELETE /users/:username' do
    it 'deletes an existing user' do
      user = create(:user)
      token = generate_jwt_token(user)
      headers = { 'Authorization' => token }

      delete "/users/#{user.username}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(User.exists?(user.username)).to be_falsey
    end
  end
end

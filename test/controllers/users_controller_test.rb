require 'test_helper'

describe UsersController do
  before do
  end

  describe 'GET /users' do
    it 'should successfully fetch all Users' do
      @expected_users = User.all

      get users_url, as: :json
      assert_response :ok

      response_users = json_response['users']
      assert_instance_of Array, response_users

      assert_ids @expected_users.pluck(:id), response_users, 'id'

      expected_keys = %w(id email gravatar_url admin created_at updated_at links)
      assert_keys expected_keys, response_users.first
    end
  end

  describe 'GET /users/:id' do
  end

  describe 'POST /users' do
  end

  describe 'PATCH /users/:id' do
  end

  describe 'DELETE /users/:id' do
  end
end

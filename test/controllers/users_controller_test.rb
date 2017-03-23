require 'test_helper'

describe UsersController do
  before do
    @user = users(:admin)
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
    it 'should successfully fetch the requested User' do
      get user_url(@user)
      assert_response :ok

      response_user = json_response['user']

      expected_keys = %w(id email gravatar_url admin created_at updated_at
                         links active_boards)
      assert_keys expected_keys, response_user

      assert_equal @user.id, response_user['id']
      assert_equal @user.email, response_user['email']
      assert_equal @user.gravatar_url, response_user['gravatar_url']

      self_link = { 'rel' => 'self', 'href' => user_url(@user) }
      assert_link self_link, response_user, 'links'

      boards_link = { 'rel' => 'boards', 'href' => user_boards_url(@user) }
      assert_link boards_link, response_user, 'links'

      board_ids = @user.boards.where(archived: [false, nil]).pluck(:id)
      assert_ids board_ids, response_user['active_boards'], 'id'
    end
  end

  describe 'POST /users' do
  end

  describe 'PATCH /users/:id' do
  end

  describe 'DELETE /users/:id' do
  end
end

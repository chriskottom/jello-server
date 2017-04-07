require 'test_helper'

describe V4::UsersController do
  include Serialization::JSONAPI::Assertions
  include Serialization::JSONAPI::ControllerAssertions
  include Serialization::JSONAPI::Helpers

  before do
    @user = users(:admin)
    @per_page = 3
  end

  describe 'GET /v4/users' do
    it 'should successfully fetch the first page of Users' do
      page = 1
      @expected_users = User.page(page).per(@per_page)
      get v4_users_url(page: { number: page, size: @per_page }),
          headers: auth_headers(user: @user),
          as: :json

      assert_response :ok
      assert_jsonapi_content_type

      assert_instance_of Array, response_users
      assert_equal @per_page, response_users.count

      response_ids = response_users.map { |u| u['id'] }
      assert_ids @expected_users.ids, response_users, 'id'

      expected_keys = %w( id type attributes relationships links )
      assert_keys expected_keys, response_users.first

      response_links = json_response.dig('links')
      assert_keys %w( self next last ), response_links
    end

    it 'should paginate the fetched Users' do
      page = 3
      @expected_users = User.page(page).per(@per_page)
      get v4_users_url(page: { number: page, size: @per_page }),
          headers: auth_headers(user: @user),
          as: :json

      assert_ids @expected_users.ids, response_users, 'id'

      response_links = json_response.dig('links')
      assert_keys %w( self next last first prev ), response_links
    end

    describe 'with a bad access token' do
      it 'should respond with :unauthorized' do
        headers = { 'Authorization' => 'Bearer flibble-di-doo' }
        get v4_users_url, headers: headers, as: :json
        assert_unauthorized_response('The access token is invalid')
      end
    end

    describe 'with no access token' do
      it 'should respond with :unauthorized' do
        get v4_users_url, as: :json
        assert_unauthorized_response('The access token is invalid')
      end
    end
  end

  describe 'GET /v4/users/:id' do
    it 'should successfully fetch the requested User' do
      get v4_user_url(@user), headers: auth_headers(user: @user), as: :json
      assert_response :ok

      expected_keys = %w( id type attributes relationships links)
      assert_keys expected_keys, response_user

      assert_equal @user.id.to_s, response_user['id']
      assert_equal @user.email, response_user.dig('attributes', 'email')
      assert_equal @user.gravatar_url, response_user.dig('attributes', 'gravatar-url')

      assert_equal v4_user_url(@user), json_response.dig('data', 'links', 'self')

      expected_board_ids = @user.boards.where(archived: [false, nil]).ids
      actual_boards = json_response.dig('data', 'relationships', 'active-boards', 'data')
      actual_board_ids = actual_boards.map { |b| b['id'] }
      assert_equal expected_board_ids.map(&:to_s).sort, actual_board_ids.sort
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        get v4_user_url(id: 'jim'), headers: auth_headers(user: @user), as: :json
        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  describe 'POST /v4/users' do
    it 'should create and respond with a new User' do
      user_attributes = {
        email: 'jim@example.com',
        password: 'secret',
        password_confirmation: 'secret'
      }

      assert_difference('User.count') do
        post v4_users_url,
             headers: auth_headers(user: @user),
             params: { user: user_attributes },
             as: :json
      end

      assert_response :created

      expected_keys = %w( id type attributes relationships links )
      assert_keys expected_keys, response_user

      assert_equal user_attributes[:email], response_user.dig('attributes', 'email')
      refute_nil response_user.dig('attributes', 'gravatar-url')

      assert_empty response_user.dig('relationships', 'active-boards', 'data')
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        assert_no_difference('User.count') do
          post v4_users_url,
               headers: auth_headers(user: @user),
               params: { user: user_attributes },
               as: :json
        end

        expected_errors = { 'email' => ["can't be blank"],
                            'password' => ["can't be blank"] }
        assert_failed_validation_response expected_errors
      end
    end
  end

  describe 'PATCH /v4/users/:id' do
    it 'should update the requested User' do
      user_attributes = { email: 'jim@example.com' }

      update_time = 1.day.from_now.change(usec: 0)  # truncate milliseconds
      travel_to update_time

      patch v4_user_url(@user),
            headers: auth_headers(user: @user),
            params: { user: user_attributes },
            as: :json
      assert_response :ok

      assert_equal user_attributes[:email], response_user.dig('attributes', 'email')
      assert_equal update_time.as_json, response_user.dig('attributes', 'updated-at')

      travel_back
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        assert_no_difference('User.count') do
          patch v4_user_url(@user),
                headers: auth_headers(user: @user),
                params: { user: user_attributes },
                as: :json
        end

        expected_errors = { 'email' => ["can't be blank"] }
        assert_failed_validation_response expected_errors
      end
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        user_attributes = { email: 'jim@example.com' }

        patch v4_user_url(id: 'jim'),
              headers: auth_headers(user: @user),
              params: { user: user_attributes },
              as: :json

        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  describe 'DELETE /v4/users/:id' do
    it 'should successfully delete the requested User' do
      assert_difference('User.count', -1) do
        delete v4_user_url(@user), headers: auth_headers(user: @user), as: :json
      end

      assert_response :no_content
      assert_empty response.body
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        assert_no_difference('User.count') do
          delete v4_user_url(id: 'jim'),
                 headers: auth_headers(user: @user),
                 as: :json
        end

        assert_not_found_response("Couldn't find User with 'id'=jim")
      end
    end
  end

  private

  def response_users
    json_response['data']
  end

  def response_user
    json_response['data']
  end
end

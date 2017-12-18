require 'sinatra/base'
require 'securerandom'
require_relative './fixtures_helper'

class RockMock < Sinatra::Base
  GET_REQUESTS = {
    families: 'Groups/GetFamilies/:id',
    groups: 'Groups',
    people_search: 'People/Search',
    phone_numbers: 'PhoneNumbers'
  }.freeze

  POST_REQUESTS = {
    create_group_member: 'GroupMembers'
  }.freeze

  GET_REQUESTS.each do |json, end_point|
    get "/api/#{end_point}" do
      json_response 200, "#{json}.json"
    end
  end

  POST_REQUESTS.each do |json, end_point|
    post "/api/#{end_point}" do
      json_response 201, "#{json}.json"
    end
  end

  post '/api/Auth/Login' do
    content_type :json

    response['Cache-Control'] = 'no-cache'
    response['Content-Secuity-Policy'] = "frame-ancestors 'self'"
    response['Date'] = Time.now.httpdate
    response['Expires'] = '-1'
    response['Pragma'] = 'no-cache'
    response['Set-Cookie'] = [
      ".ROCK=#{SecureRandom.hex(100)}",
      "expires=#{(Time.now + 14).httpdate}",
      'path=/',
      'HttpOnly'
    ].join('; ')
    response['X-Frame-Options'] = 'SAMEORIGIN'

    status 204
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    FixturesHelper.read(file_name)
  end
end

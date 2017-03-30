class V3::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
end

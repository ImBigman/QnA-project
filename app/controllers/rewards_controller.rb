class RewardsController < ApplicationController
  before_action :authenticate_user!

  skip_authorization_check

  def index
    @rewards = current_user.rewards
  end
end

class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @link = Link.find(params[:id])
    resource = @link.linkable

    if current_user.owner?(resource)
      @link.destroy
    else
      flash[:alert] = 'Not enough permission: for delete'
    end
  end
end

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if current_user.owner?(attachment.record)
      attachment.purge_later
    else
      flash[:alert] = 'Not enough permission: for delete'
    end
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment

end

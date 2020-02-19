class AttachmentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def destroy
    attachment.purge_later if current_user.owner?(attachment.record)
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment

end

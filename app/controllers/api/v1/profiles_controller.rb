module Api
  module V1
    class ProfilesController < BaseController

      authorize_resource class: User

      def me
        render json: current_resource_owner
      end

      def other_users
        render json: User.all.where.not(id: current_resource_owner.id)
      end
    end
  end
end

class SearchController < ApplicationController
  skip_authorization_check

  def index; end

  def searching
    search = SearchingService.new(search_params)
    search.call
    render json: { scope: search.scope, response: search.result, count: search.result.count }
  end

  private

  def search_params
    params.require(:search).permit(:body, :scope)
  end
end

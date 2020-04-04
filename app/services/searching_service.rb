class SearchingService
  attr_reader :request, :scope, :result

  def initialize(search_params)
    @scope = search_params[:scope].capitalize
    @query = search_params[:body]
  end

  def call
    @request = @query.split(/'([^']+)'|"([^"]+)"|\s+|\+/).reject(&:empty?).map(&:inspect)
    @result = if @scope == 'Global'
                ThinkingSphinx.search @request.to_s
              else
                @scope.singularize.constantize.search @request.to_s
              end
  end
end

module ApplicationHelper
  def flash_header
    if flash[:alert]
      render inline: "<%= content_tag :div, flash[:alert], class: 'alert alert-danger', role:'alert'%><br>"
    elsif flash[:notice]
      render inline: "<%= content_tag :div, flash[:notice], class: 'alert alert-success', role:'alert'%><br>"
    end
  end

  def javascript_link_tag(link)
    render inline: '<script src=' + link.url + '.js></script>'
  end

  def collection_cache_keys_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end

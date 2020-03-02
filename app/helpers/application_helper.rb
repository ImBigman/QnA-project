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

  def pathfinder(action, resource)
    "/#{resource.class.name.downcase.pluralize}/#{resource.id}/#{action}"
  end
end

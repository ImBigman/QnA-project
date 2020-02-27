module ApplicationHelper
  def flash_header
    if flash[:alert]
      render inline: "<%= content_tag :div, flash[:alert], class: 'alert alert-danger', role:'alert'%><br>"
    elsif flash[:notice]
      render inline: "<%= content_tag :div, flash[:notice], class: 'alert alert-success', role:'alert'%><br>"
    end
  end

  def gist_tag_helper(link)
    '<script src=' + link.url + '.js></script>'
  end
end

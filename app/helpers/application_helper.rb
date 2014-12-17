module ApplicationHelper

  def page_header(title, &block)
    content_for(:title, title)  
    html = '<div class="page-header">'.html_safe

    if block
      html += '<div class ="pull-right">'.html_safe
      html += capture do
        block.call
      end
      html += '</div>'.html_safe
    end

    html += '<h1>'.html_safe
    html += title
    html += '</h1>'.html_safe
    html += '</div>'.html_safe
    html
  end

end


# <div class="page-header">
#   <div class="pull-right">
#     <%= link_to 'New Project', new_project_path, class:"btn btn-primary" %>
#   </div>
#   <h1>Projects</h1>
# </div>

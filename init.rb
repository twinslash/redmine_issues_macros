require 'redmine'
require 'redmine_issues_macros'
require 'uri'
Redmine::Plugin.register :redmine_issues_macros do
  name 'Redmine Issues Macros plugin'
  author 'Twinslash'
  description 'Add child_issues macros for issue description'
  version '0.0.1'
  url 'https://github.com/twinslash/redmine_issues_macros'
  author_url 'twinslash.com'
end

Redmine::WikiFormatting::Macros.register do
  desc "Insert the name of the current user. Example: !{{username}}"
  macro :child_issues do |obj, args|

    if params[:controller] == 'issues' && params[:action] == 'show'
      content = @issue.tree_child.insert(0, "<br/>")
      links = URI::extract( content, ['http', 'https'] )
      content = auto_link content
    end

  end
end

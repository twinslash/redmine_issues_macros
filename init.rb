require 'redmine'
require 'redmine_issues_macros'
require 'uri'
Redmine::Plugin.register :redmine_issues_macros do
  name 'Redmine Issues Macros plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
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

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
  desc "Insert the description of the sub tasks. Example: !{{child_issues}}"
  macro :child_issues do |obj, args|
    p "========================================"
    p args
    unless args.empty? #level_param=(all|1,2,3...), subject_param=(3|none,1,2,3...), task_param
      level_arg, subject_arg, task_arg = args[0..2]
      level_arg  = level_arg.to_i  unless level_arg == ''
      subject_arg = subject_arg.empty? ? 3 : subject_arg.to_i
    end

    if params[:controller] == 'issues'
      content = Issue.find(obj.id).tree_child(level_arg, subject_arg, task_arg).insert(0, "<br/>")
      links = URI::extract( content, ['http', 'https'] )
      content = auto_link content
      case task_arg
        when "link"
          content.gsub!(/ #(\d+)/) { |id| "#{link_to_issue(Issue.find(id.delete(' #')), :subject => false, :tracker => false)}"}.html_safe
        when "full"
          content.gsub!(/ #(\d+)/) { |id| "#{link_to_issue(Issue.find(id.delete(' #')), :subject => true, :tracker => true)}"}.html_safe
        else
          content.gsub!(/ #(\d+)/,"").html_safe
      end
    end
  end
end

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

      level_arg, subject_arg, task_arg = args[0..2] unless args.nil? || args.empty?

      if level_arg.nil? || level_arg == ''
        level_arg = 'all'
      else
        level_arg = level_arg.to_i
      end

      if subject_arg.nil? || subject_arg.empty?
        subject_arg = 3
      else
        subject_arg = subject_arg.to_i unless subject_arg == 'none'
      end


    if params[:controller] == 'issues'
      content = Issue.find(obj.id).tree_child(level_arg, subject_arg, task_arg).insert(0, "<br/>")
      content = auto_link content
      case task_arg
        when "link"
          content.gsub!(/ #(\d+)/) { |id| " #{link_to_issue(Issue.find(id.delete('#')), :subject => false, :tracker => false)}"}.html_safe
        when "full"
          content.gsub!(/ #(\d+)/) { |id| " #{link_to_issue(Issue.find(id.delete('#')), :subject => true, :tracker => true)}"}.html_safe
        else
          content.gsub!(/ #(\d+)/,"").html_safe
      end
    end
  end

  desc "Insert the description of the related tasks. Example: !{{related_issues}}"
  macro :related_issues do |obj, args|

      level_arg, subject_arg, task_arg = args[0..2] unless args.nil? || args.empty?

      if level_arg.nil? || level_arg == ''
        level_arg = 'all'
      else
        level_arg = level_arg.to_i
      end

      if subject_arg.nil? || subject_arg.empty?
        subject_arg = 3
      else
        subject_arg = subject_arg.to_i unless subject_arg == 'none'
      end


    if params[:controller] == 'issues'
      content = Issue.find(obj.id).tree_related(level_arg, subject_arg, task_arg).insert(0, "<br/>")
      content = auto_link content
      case task_arg
        when "link"
          content.gsub!(/ #(\d+)/) { |id| " #{link_to_issue(Issue.find(id.delete('#')), :subject => false, :tracker => false)}"}.html_safe
        when "full"
          content.gsub!(/ #(\d+)/) { |id| " #{link_to_issue(Issue.find(id.delete('#')), :subject => true, :tracker => true)}"}.html_safe
        else
          content.gsub!(/ #(\d+)/,"").html_safe
      end
    end
  end

  desc "Insert the description of the passed tasks. Example: !{{issue}}"
  macro :issue do |obj, args|

      task_id, subject_arg, task_arg = args[0..2] unless args.nil? || args.empty?

      if task_id.nil? || task_id == ''
        content = 'Fill the necessary argument: !{{issue(task_id)}}'
      else
        task_id = task_id.to_i
        if User.current.allowed_to?(:view_issues, Issue.find(task_id).project)
          if subject_arg.nil? || subject_arg.empty?
            subject_arg = 3
          else
            subject_arg = subject_arg.to_i unless subject_arg == 'none'
          end

            content = Issue.find(task_id).representate_issue(subject_arg, task_arg).insert(0, "<br/>")
            content.gsub!(/(\{\{related_issues.*\}\})/) { Issue.find(task_id).tree_related('all', subject_arg, task_arg)}
            content.gsub!(/(\{\{child_issues.*\}\})/) { Issue.find(task_id).tree_child('all', subject_arg, task_arg)}
            content = auto_link content
            case task_arg
              when "link"
                content.gsub!(/ #(\d+)/) { |id| " #{link_to_issue(Issue.find(id.delete('#')), :subject => false, :tracker => false)}"}.html_safe
              when "full"
                content.gsub!(/ #(\d+)/) { |id| " #{link_to_issue(Issue.find(id.delete('#')), :subject => true, :tracker => true)}"}.html_safe
              else
                content.gsub!(/ #(\d+)/,"").html_safe
            end
        else
            ""
        end
      end
  end
end

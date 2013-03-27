require 'redmine'
require 'redmine_issues_macros'
require 'uri'
Redmine::Plugin.register :redmine_issues_macros do
  name 'Redmine Issues Macros plugin'
  author 'Twinslash'
  description 'Add child_issues, related_issues macroses for issue description and issue(id) for wiki pages'
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

      content = textilizable(tree_child(Issue.find(obj.id),level_arg, subject_arg, task_arg))
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

    unless obj.nil?
      content = textilizable(tree_related(Issue.find(obj.id),level_arg, subject_arg, task_arg))
    else
      content=""
    end
  end

  desc "Insert the description of the passed tasks. Example: !{{issue(id)}}"
  macro :issue do |obj, args|

    task_id, subject_arg, task_arg = args[0..2] unless args.nil? || args.empty?
    issue = Issue.find(task_id)
    if task_id.nil? || task_id == ''
      content = 'Fill the necessary argument: !{{issue(task_id)}}'
    else
      content ||= ""
      task_id = task_id.to_i
      if issue.visible?
        if subject_arg.nil? || subject_arg.empty?
          subject_arg = 3
        else
          subject_arg = subject_arg.to_i unless subject_arg == 'none'
        end

        if subject_arg == 'none'
        content += ""
        elsif subject_arg.is_a?(Fixnum)
          content += "\r\n\r\n"
          case task_arg
            when 'full'
              content += "h#{subject_arg}. #{issue.tracker.name} ##{issue.id} #{issue.subject}"
            when 'link'
              content += "h#{subject_arg}. #{issue.subject} ##{issue.id}"
            else
              content += "h#{subject_arg}. #{issue.subject}"
          end
          content += "\r\n\r\n"
          content = textilizable content
        end
        content += textilizable(issue, :description)
      else
        "N/A"
      end
    end
    content.html_safe
  end
end

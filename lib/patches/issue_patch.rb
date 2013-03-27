module IssuePatch
  def self.included(base)

    base.class_eval do

      def tree_child(issue, level_arg, subject_arg, task_arg)
        content ||= ""
        if level_arg == 'all' || level_arg > 0
          issue.children.each do |child|
            content += "\r\n\r\n"
            if subject_arg == 'none'
              content += ""
            elsif subject_arg.is_a?(Fixnum)
              case task_arg
                when 'full'
                  content += "h#{subject_arg}. #{child.tracker.name} ##{child.id} #{child.subject}"
                when 'link'
                  content += "h#{subject_arg}. #{child.subject} ##{child.id}"
                else
                  content += "h#{subject_arg}. #{child.subject}"
              end
            end
            content += "\r\n\r\n#{child.description}"
            content += tree_child(child, level_arg == 'all' ? 'all' : level_arg -1, subject_arg == 'none' ? 'none' : subject_arg + 1, task_arg)
            content += "\r\n\r\n"
          end
        end
        return content
      end


      def tree_related(issue, level_arg, subject_arg, task_arg)
        content ||= "\r\n"
        if level_arg == 'all' || level_arg > 0
          (issue.relations_from.map(&:issue_to_id) + issue.relations_to.map(&:issue_from_id)).each do |related_id|
            related_issue  = Issue.find(related_id)
            content += "\r\n\r\n"
            if subject_arg == 'none'
              content += ""
            elsif subject_arg.is_a?(Fixnum)
              case task_arg
                when 'full'
                  content += "h#{subject_arg}. #{related_issue.tracker.name} ##{related_issue.id} #{related_issue.subject}"
                when 'link'
                  content += "h#{subject_arg}. #{related_issue.subject} ##{related_issue.id}"
                else
                  content += "h#{subject_arg}. #{related_issue.subject}"
              end
            end
            content += "\r\n\r\n#{related_issue.description}"
            content += tree_child(related_issue, level_arg == 'all' ? 'all' : level_arg -1, subject_arg == 'none' ? 'none' : subject_arg + 1, task_arg)
            content += "\r\n\r\n"
          end
        end
        return content
      end

    end
  end
end

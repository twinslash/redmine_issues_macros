module IssuePatch
  def self.included(base)

    base.class_eval do

      def tree_child(issue, level_arg, subject_arg, task_arg)
        content ||= "\r\n"
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
          issue.relations_from.map(&:issue_to_id).each do |related_id|
            issue  = Issue.find(related_id)
            content += "\r\n\r\n"
            if subject_arg == 'none'
              content += ""
            elsif subject_arg.is_a?(Fixnum)
              case task_arg
                when 'full'
                  content += "h#{subject_arg}. #{issue.tracker.name} ##{issue.id} #{issue.subject}"
                when 'link'
                  content += "h#{subject_arg}. #{issue.subject} ##{issue.id}"
                else
                  content += "h#{subject_arg}. #{issue.subject}"
              end
            end
            content += "\r\n\r\n#{issue.description}"
            content += tree_child(issue, level_arg == 'all' ? 'all' : level_arg -1, subject_arg == 'none' ? 'none' : subject_arg + 1, task_arg)
            content += "\r\n\r\n"
          end
        end
        return content
      end

      def representate_issue(subject_arg, task_arg)
        content ||= ""
        if subject_arg == 'none'
          content += ""
        elsif subject_arg.is_a?(Fixnum)
          case task_arg
            when 'full'
              content += " <h#{subject_arg}> ##{self.id} </h#{subject_arg}>"
            when 'link'
              content += " <h#{subject_arg}> #{self.subject} ##{self.id} </h#{subject_arg}>"
            else
              content += " <h#{subject_arg}> #{self.subject} ##{self.id} </h#{subject_arg}>"
          end
          content += RedCloth.new(self.description).to_html + "<br>"
        end
        return content
      end
    end
  end
end

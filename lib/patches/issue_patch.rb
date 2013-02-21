module IssuePatch
  def self.included(base)

    base.class_eval do

      def tree_child(level_arg, subject_arg, task_arg)
        content ||= ""
        if level_arg == 'all' || level_arg > 0
          self.children.each_with_index do |child|
            if subject_arg == 'none'
              content += ""
            elsif subject_arg.is_a?(Fixnum)
              case task_arg
                when 'full'
                  content += " <h#{subject_arg}> ##{child.id} </h#{subject_arg}>"
                when 'link'
                  content += " <h#{subject_arg}> #{child.subject} ##{child.id} </h#{subject_arg}>"
                else
                  content += " <h#{subject_arg}> #{child.subject} ##{child.id} </h#{subject_arg}>"
              end
            end
            content += RedCloth.new(child.description).to_html + "<br>"
            content += child.tree_child(level_arg=='all' ? 'all' : level_arg -1, subject_arg == 'none' ? 'none' : subject_arg + 1, task_arg)
          end
        end
        return content
      end

    end

  end
end

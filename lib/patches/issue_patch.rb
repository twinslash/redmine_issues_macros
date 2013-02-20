module IssuePatch
  def self.included(base)

    base.class_eval do

      def tree_child(level_arg, subject_arg, task_arg)
        content ||= ""
        if level_arg >= 0
           self.children.each_with_index do |child|
            content += "  <h#{subject_arg}> #{child.subject} #{task_arg.empty? ? "" : "##{child.id}"} </h#{subject_arg}>"
            content += RedCloth.new(child.description).to_html + "<br>"
            content += child.tree_child(level_arg - 1, subject_arg + 1, task_arg)
          end
        end
        return content
      end

    end

  end
end

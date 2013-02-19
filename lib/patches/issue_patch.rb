module IssuePatch
  def self.included(base)

    base.class_eval do

      def size_def(issue, size = 2)
        size = size_def(issue.parent, size + 1) if issue.parent_id?
        size
      end

      def tree_child
        content = ""
        if self.children?
           self.children.each_with_index do |child|

            size = size_def(child)
            content += "  <h#{size}> #{child.subject} (<a href=\"/issues/#{child.id}\">#{child.id}</a>) </h#{size}>"
            content += RedCloth.new(child.description).to_html + "<br>"
            child.tree_child
          end
        end
        return content
      end

    end

  end
end

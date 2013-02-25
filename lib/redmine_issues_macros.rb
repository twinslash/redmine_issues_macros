require 'patches/issue_patch'

Rails.configuration.to_prepare do
  ApplicationHelper.send(:include, IssuePatch)
end



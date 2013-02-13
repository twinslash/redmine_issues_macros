require 'patches/issue_patch'

Rails.configuration.to_prepare do
  Issue.send(:include, IssuePatch)
end

require 'break_dance/version'
require 'break_dance/security_policies_holder'
require 'break_dance/security_scoping'
require 'break_dance/controller_additions'

ActiveRecord::Base.send(:include, BreakDance::SecurityScoping)

module BreakDance
  class AccessDenied < StandardError
  end

  class NotLoggedIn < StandardError
  end
end

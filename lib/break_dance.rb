require 'request_store'

require 'break_dance/controller_additions'
require 'break_dance/exceptions'
require 'break_dance/security_policy_additions'
require 'break_dance/security_policies_holder'
require 'break_dance/security_scoping'
require 'break_dance/version'

ActiveRecord::Base.send(:include, BreakDance::SecurityScoping)

module BreakDance

end

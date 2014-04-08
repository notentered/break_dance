require 'break_dance/version'
require 'break_dance/security_policies_holder'
require 'break_dance/security_scoping'
require 'break_dance/controller_additions'
require 'break_dance/exceptions'

ActiveRecord::Base.send(:include, BreakDance::SecurityScoping)

module BreakDance

end

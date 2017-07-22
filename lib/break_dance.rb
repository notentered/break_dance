require 'request_store_rails'

require 'break_dance/controller_additions'
require 'break_dance/exceptions'
require 'break_dance/security_policy_additions'
require 'break_dance/security_policies_holder'
require 'break_dance/active_record_base_additions'
require 'break_dance/active_record_relation_additions'
require 'break_dance/version'

ActiveRecord::Base.send(:include, BreakDance::ActiveRecordBaseAdditions)
ActiveRecord::Relation.send(:include, BreakDance::ActiveRecordRelationAdditions)

module BreakDance

end

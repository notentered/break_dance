module BreakDance
  module ControllerAdditions
    module ClassMethods
      def enable_authorization!
        before_filter :prepare_security_policy
        before_filter :access_filter
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :can?, :cannot?
    end

    def with_authorization?
      @with_authorization || false
    end

    # ToDo: Right now if we add new resource (and in the DB there is no record for it), it is unchecked in the form, but available to be used. Fix!
    # ToDo: If we have two rules with overriding actions and one is selected and the other is not, the second one applies 'false' for the resource. Fix!
    # ToDo: if empty permissions in the DB it should raise "not authorised"
    def can?(action, resource)
      return true unless with_authorization?

      allowed_permissions = current_permissions['resources'].select { |_,v| v == '1'}

      allowed = allowed_permissions.any? do |r|
        Thread.current[:security_policy_holder].resources[r[0].to_sym] and Thread.current[:security_policy_holder].resources[r[0].to_sym][:can].any? do |k,v|
          v = Array.wrap(v)
          k == resource.to_sym && (v.include?(:all_actions) || v.include?(action.to_sym) )
        end
      end

      allowed
    end

    def cannot?(action, resource)
      !can?(action, resource)
    end

    def current_permissions
      Permissions.for_user(current_user)
    end

    private

    def prepare_security_policy
      @with_authorization = true

      Thread.current[:security_policy_holder] = BreakDance::SecurityPoliciesHolder.new
      SecurityPolicy.new(current_user)
    end

    def access_filter
      raise BreakDance::AccessDenied.new unless request.path == root_path || can?(self.action_name ,self.controller_path)
    end

  end

end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include BreakDance::ControllerAdditions
  end
end
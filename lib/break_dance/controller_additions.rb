module BreakDance
  module ControllerAdditions
    module ClassMethods
      def enable_authorization!
        # ToDo: Try with prepend_before_filter!
        before_filter -> {
          @with_authorization = true

          Thread.current[:security_policy_holder] = BreakDance::SecurityPoliciesHolder.new
          SecurityPolicy.new(current_user)
        }

        # ToDo: now actions can be :all_actions or array of :action. Make Array.wrap in order to specify only one action without brackets (eg. [:action])
        # ToDo: The logic here will also serve for can? helpers. We will need to extract it an just use it here and in can?. It also may be suitable to make it available in the models.
        # ToDo: Too obscure. Rethink!
        before_filter -> {
          if current_user
            if current_user.permissions
              restricted_permissions = current_user.permissions['resources'].select { |_,v| v != '1'}
              restricted = restricted_permissions.any? do |r|
                Thread.current[:security_policy_holder].resources[r[0].to_sym] and Thread.current[:security_policy_holder].resources[r[0].to_sym][:resources].any? do |k,v|
                  k == self.controller_path.to_sym && (v == :all_actions || v.include?(self.action_name.to_sym) )
                end
              end

              raise AccessDenied.new if restricted
            end
          else
            # ToDo: a big pile of codesmell!
            raise BreakDance::NotLoggedIn.new unless (controller_path == 'user_sessions' and action_name != 'destroy') or controller_name == "sms_responder"
          end
        }
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :can?
    end

    def with_authorization?
      @with_authorization || false
    end

    # ToDo: Find a way to define abilities for not logged users!
    # ToDo: Consolidate with the before_filter from the application_controller.
    # ToDo: We need also cannot?
    # ToDo: Right now if we add new resource (and in the DB there is no record for it), it is unchecked in the form, but available to be used. Fix!
    # ToDo: If we have two rules with overriding actions and one is selected and the other is not, the second one applies 'false' for the resource. Fix!
    # ToDo: if empty permissions in the DB it should raise "not authorised"
    def can?(action, resource)
      return true unless with_authorization?

      restricted_permissions = current_user.permissions['resources'].select { |_,v| v != '1'}
      restricted = restricted_permissions.any? do |r|
        Thread.current[:security_policy_holder].resources[r[0].to_sym] and Thread.current[:security_policy_holder].resources[r[0].to_sym][:resources].any? do |k,v|
          k == resource.to_sym && (v == :all_actions || v.include?(action.to_sym) )
        end
      end

      !restricted
    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include BreakDance::ControllerAdditions
  end
end
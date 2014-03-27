module BreakDance
  module ControllerAdditions
    module ClassMethods
      def enable_authorization!
        # ToDo: Try with prepend_before_filter!
        before_filter -> {
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
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    extend BreakDance::ControllerAdditions::ClassMethods
  end
end
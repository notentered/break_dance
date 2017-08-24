module BreakDance
  module ApplicationRecordAdditions
    extend ActiveSupport::Concern

    class_methods do

      def default_scoped(unsecured: false)
        if RequestLocals.store[:break_dance_enabled] && !unsecured
          policy = RequestLocals.store[:break_dance_policy]

          raise PolicyNotFound.new('BreakDance::Policy is not defined. By design BreakDance requires all models to be scoped.')                                   unless policy.is_a?(BreakDance::Policy)
          raise ModelWithoutScope.new("Model \"#{self.name}\" is missing BreakDance::Policy declaration. By design BreakDance requires all models to be scoped.") unless policy.scopes.has_key?(self.name)

          super().merge(policy.scopes[self.name])
        else
          super()
        end
      end

      def unsecured!
        default_scoped unsecured: true
      end

    end

  end
end
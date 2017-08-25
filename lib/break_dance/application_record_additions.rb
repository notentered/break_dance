module BreakDance
  module ApplicationRecordAdditions
    extend ActiveSupport::Concern

    class_methods do
      # We cannot use alias_method here, because "super" of the aliased method is the "super" of the original method.
      %w(default_scoped unscoped).each do |method_name|
        define_method method_name do |unsecured: false, &block|
          if RequestLocals.store[:break_dance_enabled] && !unsecured
            policy = RequestLocals.store[:break_dance_policy]

            raise PolicyNotFound.new('BreakDance::Policy is not defined. By design BreakDance requires all models to be scoped.')                                   unless policy.is_a?(BreakDance::Policy)
            raise ModelWithoutScope.new("Model \"#{self.name}\" is missing BreakDance::Policy declaration. By design BreakDance requires all models to be scoped.") unless policy.scopes.has_key?(self.name)

            super(&block).merge(policy.scopes[self.name])
          else
            super(&block)
          end
        end
      end

      def unsecured!(&block)
        default_scoped(unsecured: true, &block)
      end

      def unsecured_unscoped!(&block)
        unscoped(unsecured: true, &block)
      end

    end

  end
end
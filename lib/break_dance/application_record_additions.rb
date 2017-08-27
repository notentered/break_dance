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

# We monkey patch target_scope by just call .unsecured! on relation = ...
# This is necessary because otherwise some parts of the BreakDance scopes leaked from some joined models.
# The worse thing here is that this method excludes some parts of the scopes. So we can end up with leaked "where"
# with no "select" or "join".
# ToDo: However This may lead to unexpected behaviour if AR changes in future version, it is not tested for STI models and I generally don't like exactly this approach.
module ActiveRecord
  module Associations
    module ThroughAssociation

      def target_scope
        scope = super
        reflection.chain.drop(1).each do |reflection|
          relation = reflection.klass.unsecured!.all
          scope.merge!(
            relation.except(:select, :create_with, :includes, :preload, :joins, :eager_load)
          )
        end
        scope
      end

    end
  end
end

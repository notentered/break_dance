module BreakDance
  module ActiveRecordBaseAdditions
    extend ActiveSupport::Concern

    included do

      default_scope -> {
        sph = RequestLocals.store[:security_policy_holder]

        if %w(ActiveRecord::SchemaMigration ActiveRecord::InternalMetadata).include? klass.name
          all
        elsif (sph.blank? || !sph.policies.has_key?(self.name)) && klass.name == 'User'
          all
        elsif klass.break_dance_not_applied?
          all
        elsif sph.blank?
          Rails.const_defined?('Console') ? all : raise(BreakDance::SecurityPolicyNotFound.new('SecurityPolicy is not defined. By design BreakDance requires all models to be scoped.'))
        elsif !sph.policies.has_key?(self.name)
          raise BreakDance::ModelWithoutScope.new("Model #{self.name} is missing SecurityPolicy declaration for BreakDance. By design BreakDance requires all models to be scoped.")
        else
          sph.policies[self.name]
        end
      }

    end

    class_methods do

      def break_dance_applied?
        Thread.current[:break_dance_applied] != false
      end

      def break_dance_not_applied?
        !break_dance_applied?
      end

      def unsecured!
        Thread.current[:break_dance_applied] = false
        scope = all
        Thread.current[:break_dance_applied] = true

        scope
      end

    end
  end
end
module BreakDance
  module SecurityScoping
    extend ActiveSupport::Concern

    module ClassMethods
      def where(scope = :chain, *options)
        scope = super(scope, *options)
        # return ActiveRecord::Relation.new(self, Arel::Table.new(table_name)) unless scope

        sph = RequestLocals.store[:security_policy_holder]
        if sph
          if sph.suppress_security_for == self.name
            sph.suppress_security_for = nil
            scope
          else
            scope.merge(sph.policies[self.name]).readonly(false)
          end
        else
          scope
        end
      end

      def unsecured
        if RequestLocals.store[:security_policy_holder]
          RequestLocals.store[:security_policy_holder].suppress_security_for = self.name
          where
        else
          self
        end
      end
    end
  end
end
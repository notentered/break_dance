module BreakDance
  module SecurityScoping
    extend ActiveSupport::Concern

    module ClassMethods
      def where(scope = :chain, *options)
        scope = super(scope, *options)
        # return ActiveRecord::Relation.new(self, Arel::Table.new(table_name)) unless scope

        sph = RequestLocals.store[:security_policy_holder]
        if sph && scope != :chain && scope.class != ActiveRecord::QueryMethods::WhereChain
          if sph.suppress_security_for == self.name
            sph.suppress_security_for = nil
            scope
          else
            scope.merge(sph.policies[self.name]).readonly(false)
            # sph.policies[self.name].merge(scope).readonly(false)
          end
        else
          scope
        end
      end

      def unsecured
        RequestLocals.store[:security_policy_holder].suppress_security_for = self.name if RequestLocals.store[:security_policy_holder]
        self
      end

    end
  end
end
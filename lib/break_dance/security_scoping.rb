module BreakDance
  module SecurityScoping
    extend ActiveSupport::Concern

    module ClassMethods
      def scoped(options = nil)
        scope = super(options)
        return ActiveRecord::Relation.new(self, Arel::Table.new(table_name)) unless scope

        sph = Thread.current[:security_policy_holder]
        if sph
          if sph.suppress_security_for == self.name
            # ToDo: the row below. If we uncomment it, it should make te insecure option temporary. Instead when rails calls some finder (:all, :find_by...)
            #       It is applied again. We need some method to remove the scope up until next finder... or eve better only for the current command.
            #sph.suppress_security_for = nil

            # ToDo: investigate about .readonly(false)
            scope
          else
            scope.merge(sph.policies[self.name]).readonly(false)
          end
        else
          scope
        end
      end

      def unsecured
        Thread.current[:security_policy_holder].suppress_security_for = self.name
        scoped
      end
    end
  end
end
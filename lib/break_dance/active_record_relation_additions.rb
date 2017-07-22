module BreakDance
  module ActiveRecordRelationAdditions
    extend ActiveSupport::Concern

    included do
      def break_dance_applied?
        raise NoMethodError.new "undefined method 'break_dance_applied?' for #{self.class.name}", :break_dance_applied?
      end

      def break_dance_not_applied?
        raise NoMethodError.new "undefined method 'break_dance_not_applied?' for #{self.class.name}", :break_dance_not_applied?
      end

      def unsecured!
        raise NoMethodError.new "undefined method 'unsecured!' for #{self.class.name}", :unsecured!
      end
    end

  end
end
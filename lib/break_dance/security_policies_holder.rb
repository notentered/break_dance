module BreakDance
  class SecurityPoliciesHolder < BasicObject
    attr_accessor :policies, :resources, :suppress_security_for

    def initialize
      @policies = {}
      @resources = {}
    end
  end
end

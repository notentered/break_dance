module BreakDance
  class SecurityPoliciesHolder
    attr_accessor :policies, :resources, :suppress_security_for

    def initialize
      @policies = {}
      @resources = {}
    end
  end
end
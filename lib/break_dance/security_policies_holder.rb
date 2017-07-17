module BreakDance
  class SecurityPoliciesHolder
    attr_accessor :policies, :resources, :suppress_security_for, :excluded_select_values

    def initialize
      @policies = {}
      @resources = {}
      @excluded_select_values = {}
    end
  end
end
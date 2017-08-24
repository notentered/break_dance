module BreakDance
  class Policy
    attr_accessor :scopes, :resources, :excluded_select_values

    def initialize
      @scopes = {}
      @resources = {}
      @excluded_select_values = {}
    end
  end
end
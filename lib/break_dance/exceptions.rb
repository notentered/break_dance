module BreakDance
  class AccessDenied < StandardError
  end

  class ModelWithoutScope < StandardError
  end

  class SecurityPolicyNotFound < StandardError
  end
end
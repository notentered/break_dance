module BreakDance
  class AccessDenied < StandardError
  end

  class PolicyNotFound < StandardError
  end

  class ModelWithoutScope < StandardError
  end
end
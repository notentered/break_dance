module BreakDance
  module SecurityPolicyAdditions
    def policy(name)
      @policy_name = name
      yield
    end

    def scope(model)
      model_name = model.name
      if @user and @user.permissions and @user.permissions['models'] and @user.permissions['models'].has_key? model_name and @user.permissions['models'][model_name] == @policy_name
        RequestStore.store[:security_policy_holder].policies[model.name] = yield(model.unscoped)
      end
    end

    def resource(key, resource)
      RequestStore.store[:security_policy_holder].resources[key] = resource
    end
  end
end
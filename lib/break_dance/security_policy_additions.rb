module BreakDance
  module SecurityPolicyAdditions
    def policy(name)
      @policy_name = name
      yield
    end

    def scope(model)
      model_name = model.name

      # if @user and @user.permissions and @user.permissions['models'] and @user.permissions['models'].has_key? model_name and @user.permissions['models'][model_name] == @policy_name
        # Just maybe... it may be better to do scope.merge here... in that way we can actually combine separate rules for same model. Not sure if sensible at all.

        RequestLocals.store[:security_policy_holder].policies[model.name] = yield(model.unscoped)
      # end
    end

    def resource(key, resource)
      RequestLocals.store[:security_policy_holder].resources[key] = resource
    end

    # ToDo: Check & fix if we need to redefine also object.attributes or any other method to return us all attributes skipping direct attribute method call
    #       I.e. we now will receive 'nil' if a "column" is excluded, but we may access it via Object.find(x).attributes[:excluded_attribute]
    def exclude_select_values(model, select_values)
      RequestLocals.store[:security_policy_holder].excluded_select_values[model.name] = select_values

      select_values.each do |sv|
        model.redefine_method sv do
          if RequestLocals.store[:security_policy_holder]&.excluded_select_values[model.name]&.include? sv
            nil
          else
            super()
          end
        end
      end
    end
  end
end
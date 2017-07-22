module BreakDance
  module SecurityPolicyAdditions
    def policy(name)
      @policy_name = name
      yield
    end

    def scope(model)
      sphm = RequestLocals.store[:security_policy_holder].policies[model.name]

      RequestLocals.store[:security_policy_holder].policies[model.name] = sphm.nil? ? yield(model.unscoped) : sphm.merge(yield(model.unscoped))
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
module BreakDance
  module PolicyAdditions
    def scope(model)
      RequestLocals.store[:break_dance_policy] ||= BreakDance::Policy.new

      model_scope = RequestLocals.store[:break_dance_policy].scopes[model.name]

      RequestLocals.store[:break_dance_policy].scopes[model.name] = model_scope.nil? ? yield(model.unscoped) : model_scope.merge(yield(model.unscoped))
    end

    def resource(key, resource)
      RequestLocals.store[:break_dance_policy].resources[key] = resource
    end

    # ToDo: Check & fix if we need to redefine also object.attributes or any other method to return us all attributes skipping direct attribute method call
    #       I.e. we now will receive 'nil' if a "column" is excluded, but we may access it via Object.find(x).attributes[:excluded_attribute]
    def exclude_select_values(model, select_values)
      RequestLocals.store[:break_dance_policy].excluded_select_values[model.name] = select_values

      select_values.each do |sv|
        model.redefine_method sv do
          if RequestLocals.store[:break_dance_policy]&.excluded_select_values[model.name]&.include? sv
            nil
          else
            super()
          end
        end
      end
    end
  end
end
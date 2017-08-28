require 'test_helper'

class SecurityPolicy
  include BreakDance::PolicyAdditions
end

class PolicyAdditionsTest < ActiveSupport::TestCase
  # ToDo: Utilize MiniTest specs
  # describe 'scope' do
  #   it 'Creates a scope in RequestLocals.store[:break_dance_policy]' do
  #     # assert_instance_of SecurityPolicy.scope (TestModel) { |m| m.where(id: 42) }, ActiveRecord::Relation
  #
  #   end
  # end

  def test_create_scope_in_request_locals
    scope = SecurityPolicy.new.scope(TestModel) { |m| m.where(id: 42) }
    assert_kind_of BreakDance::Policy, RequestLocals.store[:break_dance_policy]

    assert_kind_of ActiveRecord::Relation, scope
    assert_equal scope, RequestLocals.store[:break_dance_policy].scopes['TestModel']
  end

  def test_create_resource_in_request_locals
    resources = SecurityPolicy.new.resource :for_guests, hidden: true, can: { 'users': :all_actions }
    assert_kind_of BreakDance::Policy, RequestLocals.store[:break_dance_policy]

    assert_kind_of Hash, resources
    assert_equal resources, RequestLocals.store[:break_dance_policy].resources[:for_guests]
  end

end

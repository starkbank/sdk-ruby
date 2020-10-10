# frozen_string_literal: true

require_relative('../test_helper.rb')

describe(StarkBank::Workspace, '#workspace') do
  it 'query and get' do
    workspaces = StarkBank::Workspace.query(limit: 10)
    workspaces.each do |workspace|
      expect(workspace.id).wont_be_nil
      workspace_get = StarkBank::Workspace.get(id: workspace.id)
      expect(workspace.id).must_equal(workspace_get.id)
    end
  end
end
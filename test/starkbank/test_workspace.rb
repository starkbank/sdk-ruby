# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::Workspace, '#workspace') do
  it 'create' do
    workspace = ExampleGenerator.workspace_example
    workspace = StarkBank::Workspace.create(username: workspace.username, name: workspace.name, user: ExampleGenerator.organization_example)
    expect(workspace.id).wont_be_nil
    expect(workspace.username).wont_be_nil
    expect(workspace.name).wont_be_nil
  end

  it 'query and get' do
    organization = ExampleGenerator.organization_example
    workspaces = StarkBank::Workspace.query(limit: 2, user: organization)
    workspaces.each do |workspace|
      expect(workspace.id).wont_be_nil
      workspace_get = StarkBank::Workspace.get(workspace.id, user: StarkBank::Organization.replace(organization, workspace.id))
      expect(workspace.id).must_equal(workspace_get.id)
    end
  end
end

# frozen_string_literal: true

require_relative('../test_helper.rb')
require_relative('../example_generator.rb')

describe(StarkBank::Workspace, '#workspace') do
  it 'create and patch' do
    organization = ExampleGenerator.organization_example
    workspace = ExampleGenerator.workspace_example
    workspace = StarkBank::Workspace.create(username: workspace.username, name: workspace.name, allowed_tax_ids: workspace.allowed_tax_ids, user: ExampleGenerator.organization_example)
    expect(workspace.id).wont_be_nil
    expect(workspace.username).wont_be_nil
    expect(workspace.name).wont_be_nil

    update = ExampleGenerator.workspace_example
    workspace = StarkBank::Workspace.update(workspace.id, username: update.username, name: update.name, allowed_tax_ids: ['012.345.678-90'], user: StarkBank::Organization.replace(organization, workspace.id))
    expect(workspace.username).must_equal(update.username)
    expect(workspace.name).must_equal(update.name)
    expect(workspace.allowed_tax_ids).must_equal(['012.345.678-90'])
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

  it 'page' do
    ids = []
    cursor = nil
    workspaces = nil
    (0..1).step(1) do
      workspaces, cursor = StarkBank::Workspace.page(limit: 2, cursor: cursor, user: ExampleGenerator.organization_example)
      workspaces.each do |workspace|
        expect(ids).wont_include(workspace.id)
        ids << workspace.id
      end
      if cursor.nil?
        break
      end
    end
    expect(ids.length).must_be :==, 4
  end
end

require 'list_projects'

describe ListProjects, "self.in" do
  let(:repository) { App.repository }

  it "returns all projects" do
    project = FactoryGirl.create(:entity_project, name: "testbot")
    repository.projects.create(project)

    projects = ListProjects.in(repository)
    projects.size.should == 1
    projects.first.name.should == "testbot"
  end

  it "orders the projects alphabetically" do
    project = FactoryGirl.create(:entity_project, name: "testbot")
    repository.projects.create(project)

    project = FactoryGirl.create(:entity_project, name: "deployer")
    repository.projects.create(project)

    ListProjects.in(repository).map(&:name).should == [ "deployer", "testbot" ]
  end
end

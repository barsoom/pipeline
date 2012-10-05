require 'spec_helper'

if ENV['DB']
  puts "\nUsing the database for request tests.\n\n"
else
  puts "\nUsing the in-memory store for request tests. Specify DB=true to use the database.\n\n"
end

describe "Adding projects" do
  it "can be done" do
    visit root_path
    click_link "Add project"
    fill_in "Name", with: "Deployer"
    fill_in "Github URL", with: "https://github.com/barsoom/deployer"
    click_button "Save"
    page.should have_content("Project added.")
    current_path.should == root_path
    repository.projects.last.github_url.should == "https://github.com/barsoom/deployer"
  end

  it "reports errors" do
    visit root_path
    click_link "Add project"
    click_button "Save"
    page.should have_content("Name can't be blank")
    repository.projects.last.should be_nil
  end

  before(:each) do
    repository.projects.delete_all
  end

  def repository
    if ENV['DB']
      Repository::PG.instance
    else
      Repository::Memory.instance
    end
  end
end

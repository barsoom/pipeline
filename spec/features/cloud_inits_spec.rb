require "spec_helper"

RSpec.describe "Cloud-inits", type: :feature do
  it "can be managed" do
    visit root_path
    click_link "Cloud-inits"
    click_link "New cloud-init"

    fill_in "Name", with: "foo"
    fill_in "Content", with: "content"
    click_button "Save"
    expect(current_path).to eq(cloud_inits_path)
    expect(page).to have_content("Cloud-init was successfully created.")
    cloud_init = CloudInit.first!
    expect(cloud_init.data).to eq("content")

    click_link "Edit"
    fill_in "Name", with: "bar"
    click_button "Save"
    cloud_init.reload
    expect(cloud_init.name).to eq("bar")

    click_link "Edit"
    click_button "Remove"
    expect(current_path).to eq(cloud_inits_path)
    expect(page).to have_content("Cloud-init was successfully destroyed.")
    expect(CloudInit.all).to be_empty
  end
end

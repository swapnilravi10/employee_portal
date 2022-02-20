require "application_system_test_case"

class PostAttachmentsTest < ApplicationSystemTestCase
  setup do
    @post_attachment = post_attachments(:one)
  end

  test "visiting the index" do
    visit post_attachments_url
    assert_selector "h1", text: "Post Attachments"
  end

  test "creating a Post attachment" do
    visit post_attachments_url
    click_on "New Post Attachment"

    fill_in "Post", with: @post_attachment.post_id
    fill_in "Post image", with: @post_attachment.post_image
    click_on "Create Post attachment"

    assert_text "Post attachment was successfully created"
    click_on "Back"
  end

  test "updating a Post attachment" do
    visit post_attachments_url
    click_on "Edit", match: :first

    fill_in "Post", with: @post_attachment.post_id
    fill_in "Post image", with: @post_attachment.post_image
    click_on "Update Post attachment"

    assert_text "Post attachment was successfully updated"
    click_on "Back"
  end

  test "destroying a Post attachment" do
    visit post_attachments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Post attachment was successfully destroyed"
  end
end

class PostAttachment < ApplicationRecord
    mount_uploader :post_image, PostImageUploader
    belongs_to :post
end

class Post < ApplicationRecord
    belongs_to :user
    has_many :comments
    has_many :post_likes
    has_many :post_attachments, dependent: :destroy
    accepts_nested_attributes_for :post_attachments
    # mount_uploaders :post_images, PostImageUploader

    # validates :post_image, file_size: { less_than: 1.megabytes }
end

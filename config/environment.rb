# Load the Rails application.
require_relative "application"
require 'carrierwave/orm/activerecord'


# Initialize the Rails application.
Rails.application.initialize!

# Email configuration
ActionMailer::Base.default :content_type => "text/html"


module AWS_CONFIG
    ACCESS_KEY_ID = "AKIAVEAZ3W2XEPYBCXS5"
    SECRET_ACCESS_KEY = "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"
    REGION = "us-east-2"
    BUCKET = "anveshak-employee-documents"
end
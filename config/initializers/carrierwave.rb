CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
        provider:              'AWS',
        aws_access_key_id:     'AKIAVEAZ3W2XEPYBCXS5',
        aws_secret_access_key: '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',
        region:                'us-east-2',
    }
    config.fog_directory  = 'anveshak-post-images'
  end
# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path('spec/fixtures/cassette_library')
  c.hook_into                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { record: :once }
  c.debug_logger             = File.open('vcr.log', 'w')
  c.configure_rspec_metadata!
  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end

  c.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == 'ASCII-8BIT' ||
      !http_message.body.valid_encoding?
  end
end

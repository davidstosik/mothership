github_pr = "https://github.com/rails/rails/pull/32580"
compatible_version = "5.2.0"

if Rails.version > "6"
  raise <<~ERROR
    This backport may not be necessary anymore!
    #{github_pr}
  ERROR
elsif Rails.version > compatible_version
  raise <<~ERROR
    Please make sure this backport is still valid and bump the version number in #{File.expand_path(__FILE__)}.
    #{github_pr}
  ERROR
end

require "rails/generators/rails/master_key/master_key_generator"

if Rails.application.credentials.respond_to?(:key_path)
  Rails::Generators::MasterKeyGenerator.send(:remove_const, :MASTER_KEY_PATH)
  Rails::Generators::MasterKeyGenerator.const_set("MASTER_KEY_PATH", Rails.application.credentials.key_path.relative_path_from(Rails.root))
end

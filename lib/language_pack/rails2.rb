require "fileutils"
require "language_pack"
require "language_pack/rack"

# Rails 2 Language Pack. This is for any Rails 2.x apps.
class LanguagePack::Rails2 < LanguagePack::Ruby

  # detects if this is a valid Rails 2 app
  # @return [Boolean] true if it's a Rails 2 app
  def self.use?
    super && File.exist?("config/environment.rb")
  end

  def name
    "Ruby/Rails"
  end

  def default_config_vars
    super.merge({
      "RAILS_ENV" => "production",
      "RACK_ENV" => "production"
    })
  end

  def default_process_types
    web_process = gem_is_bundled?("thin") ?
                    "bundle exec thin start -e $RAILS_ENV -p $PORT" :
                    "bundle exec ruby script/server -p $PORT"

    super.merge({
      "web" => web_process,
      "worker" => "bundle exec rake jobs:work",
      "console" => "bundle exec script/console"
    })
  end

private

  # most rails apps need a database
  # @return [Array] shared database addon
  def add_shared_database_addon
    ['shared-database:5mb']
  end

  # sets up the profile.d script for this buildpack
  def setup_profiled
    super
    set_env_default "RACK_ENV",  "production"
    set_env_default "RAILS_ENV", "production"
  end

end


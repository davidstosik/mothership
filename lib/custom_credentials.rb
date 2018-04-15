module CustomCredentials
  def credentials
    @credentials ||= custom_credentials
  end

  private

    def credentials_file_path
      "config/credentials.#{Rails.env}.yml.enc"
    end

    def master_key_file_path
      "config/master.#{Rails.env}.key"
    end

    def custom_credentials
      if Rails.env.test?
        OpenStruct.new(YAML.load_file("config/credentials.test.yml"))
      else
        encrypted(
          credentials_file_path,
          key_path: master_key_file_path
        )
      end
    end
end

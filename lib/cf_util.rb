class CfUtil

  def self.couchdb_settings
    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
    if !instance_index.nil?
      puts "Instance index: ", instance_index, "\n"

      # Get the couchdb credentials from the user-provided service created and bound to app
      # (You could also find by tag, if you prefer to use different ups names in different environments, i.e. couchdb-dev, etc)
      credentials = CF::App::Credentials.find_by_service_name(Settings.couchdb_ups) rescue nil
      if credentials.nil?
        raise ArgumentError, "unable to get cf credentials for couchdb using ups name:  (#{Settings.couchdb_ups})"
      end

      couchdb_url = credentials['url']
      microposts_db = credentials['db']

    # else running locally/outside of CF
    else
      couchdb_url = Settings.couchdb_url
      microposts_db = Settings.microposts_db
    end

    if (couchdb_url.nil? || microposts_db.nil?)
      raise ArgumentError, "couchdb_url (#{couchdb_url}) and/or microposts_db (#{microposts_db}) not set"
    end

    puts "\n\n"
    puts 'Couchdb url: ', couchdb_url
    puts 'Microposts db: ', microposts_db
    puts "\n\n"

    return [couchdb_url, microposts_db]
  end

end
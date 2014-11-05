class DocDb

  def self.open_db

    # if running in CF
    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
    if !instance_index.nil?
    #unless instance_index.nil?
      puts "Instance index: ", instance_index, "\n"

      # Get credentials for the service instance with the given name
      credentials = CF::App::Credentials.find_by_service_name(Settings.couchdb_ups) rescue nil
      if credentials.nil?
        raise ArgumentError, "unable to get cf credentials for couchdb using ups name:  #{Settings.couchdb_ups}"
      end

      couchdb_url = credentials['url']
      microposts_db = credentials['db']


      credentials = CF::App::Credentials.find_by_service_name('vcenter-dev')
      host = credentials['host']
      puts 'host: ', host
      port = credentials['port']
      puts 'port: ', port
      puts "\n\n"

      # @services ||= JSON.parse(ENV['VCAP_SERVICES']).values.flatten
      # puts 'services: ', @services

    # else running locally/outside of CF
    else
      puts "\n\n"
      puts 'Settings url: ', Settings.couchdb_url
      puts 'Settings db: ', Settings.microposts_db
      puts "\n\n"
      couchdb_url = Settings.couchdb_url
      microposts_db = Settings.microposts_db
    end

    if (couchdb_url.nil? || microposts_db.nil?)
      raise ArgumentError, "couchdb_url (#{couchdb_url}) and/or microposts_db (#{microposts_db}) not set"
    end

    couch = CouchRest.new(couchdb_url)
    db = couch.database(microposts_db)
    return db

  end


end
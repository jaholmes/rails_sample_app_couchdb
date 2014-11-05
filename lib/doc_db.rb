class DocDb

  def self.open_db
    puts "\n\n"
    puts 'Settings url: ', Settings.couchdb_url
    puts 'Settings db: ', Settings.microposts_db
    puts "\n\n"

    instance_index = JSON.parse(ENV["VCAP_APPLICATION"])["instance_index"] rescue nil
    unless instance_index.nil?
      puts "Instance index: ", instance_index, "\n"

      # Get credentials for the service instance with the given name
      credentials = CF::App::Credentials.find_by_service_name('postgresql-dev')
      db_url = credentials['uri']
      puts 'CF db url: ', db_url
      puts "\n\n"

      credentials = CF::App::Credentials.find_by_service_name('vcenter-dev')
      host = credentials['host']
      puts 'host: ', host
      port = credentials['port']
      puts 'port: ', port
      puts "\n\n"


      @services ||= JSON.parse(ENV['VCAP_SERVICES']).values.flatten

      puts 'services: ', @services
      puts "\n\n"

    end

    couch = CouchRest.new(Settings.couchdb_url)
    db = couch.database(Settings.microposts_db)
    return db
  end

end
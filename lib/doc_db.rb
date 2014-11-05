class DocDb

  def self.open_db
    couch = CouchRest.new(Settings.couchdb_url)
    db = couch.database(Settings.microposts_db)
    return db
  end

end
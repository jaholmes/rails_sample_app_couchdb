require 'cf_util'

class DocDb

  def self.open_db

    couchdb_url, microposts_db = CfUtil.couchdb_settings
    couch = CouchRest.new(couchdb_url)
    db = couch.database(microposts_db)
    return db

  end


end
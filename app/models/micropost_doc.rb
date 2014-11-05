class MicropostDoc
  require 'doc_db'

  def initialize(user_id, content)
    @user_id = user_id
    @content = content
  end

  def user_id
    @user_id
  end

  def content
    @content
  end

  # Returns microposts from the given user
  def self.from_this_user(user)
    db = DocDb.open_db
    docs = db.view("posts/byuser?key=#{user.id}")
    return docs
  end

  def self.save(micropost)
    doc = MicropostDoc.new(micropost.user_id, micropost.content)
    db = DocDb.open_db
    response = db.save_doc({'user_id' => doc.user_id, 'content' => doc.content})
  end

end



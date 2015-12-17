class Post
  attr_accessor :title, :url, :points, :item_id

  def initialize
    @comments = []
  end

  def comments
    @comments
  end
  
  def add_comment(comment)
    @comments << comment 
  end
end

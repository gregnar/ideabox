class Idea

  attr_reader :title, :description, :likes

  def initialize(title, description)
    @title = title
    @description = description
    @likes = 0
  end

  def like!
    @likes += 1
  end

  def <=>(other)
    likes <=> other.likes
  end

end

class Idea
  include Comparable
  attr_reader :title, :description, :rank, :id, :raw_tags

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @raw_tags    = attributes["tags"] || []
    @rank        = attributes["rank"] || 0
    @id          = attributes["id"]
    @created_at  = attributes["created_at"]
  end

  def save
    IdeaStore.create(to_h)
  end

  def tags
    raw_tags.split(",").map(&:strip)
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

  def database
    Idea.database
  end
end

require 'yaml/store'

class IdeaStore

  def self.database
    return @database if @database

    @database = YAML::Store.new('db/ideabox')
    @database.transaction do
      database['ideas'] ||= []
    end
    @database
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.create(data)
    database.transaction do
      database['ideas'] << data
    end
  end

  def self.all_tags
    tags = all.map(&:tags)
    tags.flatten.map {|tag| tag.strip}.uniq
  end

  def self.list_of_ideas_by_tag
    ideas_by_tag = {}
    all_tags.map do |tag|
      ideas_by_tag[tag] = select_ideas_by_tag(tag)
    end
    ideas_by_tag
  end

  def self.select_ideas_by_tag(tag)
    all.select {|idea| idea.tags.include?(tag)}
  end

  def search_ideas(query)
    all.select { |idea| query_match?(idea, query) }
  end

  def query_match?(idea, query)
    attributes = [idea.title, idea.description, idea.tags]
    attributes.flatten.any? { |attribute| attribute =~ /#{query}/i }
  end
end

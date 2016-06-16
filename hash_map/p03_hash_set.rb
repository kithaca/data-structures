require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
     unless include?(key)
      resize! if @count == num_buckets
      self[key.hash % num_buckets] << key
      @count += 1
    end
  end

  def include?(key)
    self[key.hash % num_buckets].include?(key)
  end

  def remove(key)
    @count -= 1 if self[key.hash % num_buckets].delete(key)
  end

  private

  def [](num)
    @store[num.hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    buckets = num_buckets * 2
    new_store = Array.new(buckets) { Array.new }
    @store.each do |bucket|
      bucket.each { |value| new_store[value.hash % buckets] << value }
    end
    @store = new_store
  end
end

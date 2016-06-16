class MaxIntSet
  def initialize(max)
    @store = Array.new(max, false)
    @max = max
  end

  def insert(num)
    validate!(num)
    @store << num unless include?(num)
  end

  def remove(num)
    validate!(num)
    @store.delete(num)
  end

  def include?(num)
    validate!(num)
    @store.include?(num)
  end

  private

  def is_valid?(num)
    num >= 0 && num <= @max
  end

  def validate!(num)
    raise "Out of bounds" unless is_valid?(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    @store[(num % num_buckets)] << num unless include?(num)
  end

  def remove(num)
    self[num % num_buckets].delete(num)
  end

  def include?(num)
    self[num % num_buckets].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    unless include?(num)
      resize! if @count == num_buckets
      self[num % num_buckets] << num
      @count += 1
    end
  end

  def remove(num)
    @count -= 1 if self[num % num_buckets].delete(num)
  end

  def include?(num)
    self[num % num_buckets].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num]
  end

  def num_buckets
    @store.length
  end

  def resize!
    buckets = num_buckets * 2
    new_store = Array.new(buckets) { Array.new }
    @store.each do |bucket|
      bucket.each { |value| new_store[value % buckets] << value }
    end
    @store = new_store
  end
end

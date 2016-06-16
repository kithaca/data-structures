class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable

  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    return nil if i < 0 && (count + i < 0 || count + i >= count)
    return nil if i >= count
    i < 0 ? @store[count + i] : @store[i]
  end

  def []=(i, val)
    return nil if i < 0 && (count + i < 0 || count + i >= count)
    resize! if i >= capacity
    if i < 0
      @store[count + i] = val
    else
      @store[i] = val
    end
    @count += 1 if val
  end

  def capacity
    @store.length
  end

  def include?(val)
    any? { |el| el == val }
  end

  def push(val)
    resize! if count == capacity
    @store[count] = val
    @count += 1
  end

  def unshift(val)
    curr_el = first
    @store[0] = val
    @count += 1

    1.upto(capacity - 1) do |i|
      break unless curr_el
      next_el = @store[i]
      @store[i] = curr_el
      curr_el = next_el
    end
    push(curr_el)
  end

  def pop
    return nil if count == 0
    last_el = @store[count - 1]
    @store[count - 1] = nil
    @count -= 1
    last_el
  end

  def shift
    return nil if count == 0
    first_el = @store[0]
    1.upto(capacity - 1) do |i|
      @store[i - 1] = @store[i]
    end
    @count -= 1
    @store[capacity - 1] = nil

    first_el
  end

  def first
    return nil if @store.length == 0
    @store[0]
  end

  def last
    return nil if @store.length == 0

    i = capacity - 1
    last_el = @store[i]
    while !last_el && i >= 0
      last_el = @store[i]
      i -= 1
    end

    last_el
  end

  def each
    capacity.times { |i| yield @store[i] }
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    each_with_index do |el, idx|
      return false unless el == other[idx]
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    old_store = @store
    old_capacity = capacity

    @store = StaticArray.new(capacity * 2)
    old_capacity.times do |i|
      @store[i] = old_store[i]
    end
    @count = old_capacity
  end
end

a = DynamicArray.new(3)
a[2] = 0
puts a
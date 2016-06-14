require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store.each do |list|
      return true if list.include?(key)
    end
    false
  end

  def set(key, val)
    if get(key)
      bucket(key).each do |link|
        if link.key == key
          link.val = val
          break
        end
      end
    else
      resize! if num_buckets == @count
      bucket(key).insert(key, val)
      @count += 1
    end
  end

  def get_link(key)
    bucket(key).get_link(key)
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    if bucket(key).remove(key)
      @count -= 1
    end
  end

  def each
    @store.each do |list|
      link = list.first
      while (link)
        yield(link.key, link.val)
        link = link.next
      end
    end
  end

  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    new_length = num_buckets * 2
    new_store = Array.new(new_length) { LinkedList.new }
    each do |key, val|
      new_store[key.hash % new_length].insert(key, val)
    end
    @store = new_store
  end

  def bucket(key)
    @store[key.hash % num_buckets]
  end
end

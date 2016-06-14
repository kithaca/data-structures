require_relative 'p05_hash_map'
require_relative 'p04_linked_list'
require 'byebug'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      link = @map.get_link(key)
      update_link!(link)
    else
      val = calc!(key)
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    val = @prc.call(key)
    @map[key] = val
    @store.insert(key, val)
    eject! if count > @max
    val
  end

  def update_link!(link)
    @store.remove(link.key)
    @store.insert(link.key, link.val)
  end

  def eject!
    lru_link = @store.first
    @store.remove(lru_link.key)
    @map.delete(lru_link.key)
  end
end

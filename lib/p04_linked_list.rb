class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = nil
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head
  end

  def last
    return nil if @head.nil?
    current_link = @head
    until current_link.next == nil
      current_link = current_link.next
    end
    current_link
  end

  def empty?
    @head.nil?
  end

  def get(key)
    link = select { |link| link.key == key }.first
    return link ? link.val : nil
  end

  def include?(key)
    !!get(key)
  end

  def insert(key, val)
    link = Link.new(key, val)
    if empty?
      @head = link
    else
      last.next = link
      link.prev = last
    end
  end

  def remove(key)
    if include?(key)
      link = select { |link| link.key == key }.first
      new_prev = link.prev ? link.prev : nil
      new_next = link.next ? link.next : nil
      link.prev.next = new_next if link.prev
      link.next.prev = new_prev if link.next

      @head = link.next unless link.prev
    end
  end

  def each(&block)
    current_link = @head
    while (current_link)
      yield(current_link)
      current_link = current_link.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end

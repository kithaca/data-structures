class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
  	hashed = 1.hash
  	each do |val|
  		hashed += val.hash
  		hashed = hashed.hash
  	end
  	hashed.hash
  end
end

class String
  def hash
  	hashed = "a".ord.hash
  	each_char do |char|
  		hashed += char.ord.hash
  		hashed = hashed.hash
  	end
  	hashed.hash
  end
end

class Hash
  def hash
  	arr = []
  	each do |key, val|
  		arr << (key.hash + val.hash).hash
  	end
  	arr.sort.hash
  end
end

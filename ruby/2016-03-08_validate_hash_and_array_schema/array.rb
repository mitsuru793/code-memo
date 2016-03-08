class Array
  def has_shape?(shape)
    all? do |v|
      i = index(v)
      Array === v or Hash === v ? v.has_shape?(shape[i]) : shape[i] === v
    end
  end
end

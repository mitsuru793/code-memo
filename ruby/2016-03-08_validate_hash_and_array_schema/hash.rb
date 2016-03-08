class Hash
  def has_shape?(shape)
    all? do |k, v|
      Array === v or Hash === v ? v.has_shape?(shape[k]) : shape[k] === v
    end
  end
end

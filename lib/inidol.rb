class Hash
  def to_ini
    result = ''
    self.each do |key, value|
      if value.instance_of?(Hash)
        result += "\n[#{key}]\n#{value.to_ini}"
      elsif value.instance_of?(Array)
        value.each do |element|
          result += "#{key}[]=#{element}\n"
        end
      else
        result += "#{key}=#{value}\n"
      end
    end
    result
  end
end
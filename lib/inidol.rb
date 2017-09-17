require 'babel_bridge'

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

class INIHash < BabelBridge::Parser
  ignore_whitespace

  def result
    @result ||= {}
  end

  def current(this)
    @current = result[this] = {}
  end

  def current?
    @current ||= result
  end 

  rule :root, many(:body) do
    def evaluate
      body.each { |element| element.evaluate }
    end
  end

  rule :body, any(:group, :property, :comment)

  rule :group, '[', :any, ']' do
    def evaluate
      parser.current(any.evaluate)
    end
  end

  rule :property, :names, '=', :types, :comment? do
    def evaluate
      current = parser.current?[names.evaluate]

      if current.instance_of?(Array)
        current << types.evaluate
      else
        parser.current?[names.evaluate] = types.evaluate  
      end
    end
  end

  rule :names, any(:array, :name)
  rule :types, any(:float, :int, :bool, :string, :content)

  rule :int,/[-]?[0-9]+/ do
    def evaluate
      to_s.to_i
    end 
  end

  rule :dot_digits, many(/\.[0-9]+/) do
    def evaluate
      to_s.split(".")[1..-1]
    end
  end

  rule :float, :int, :dot_digits do
    def evaluate 
      after_dot = dot_digits.evaluate

      if after_dot.size <= 1
        (int.evaluate.to_s + "." + after_dot[0]).to_f
      else
        int.evaluate.to_s + "." + after_dot.join('.')
      end
    end
  end

  rule :bool, /true|false/ do
    def evaluate
      to_s == 'true'
    end
  end

  rule :string, /"(?:[^"\\\n]|\\(?:["\\\/bfnrt,]|u[0-9a-fA-F]{4}))*"/ do
    def evaluate
      to_s.chomp.gsub(/"/, '')
    end
  end

  rule :content, /[^\n\=\[\]";#]+/ do
    def evaluate
      to_s.chomp.strip
    end 
  end

  rule :array, :name, '[]' do
    def evaluate
      parser.current?[name.evaluate] = [] if not parser.current?[name.evaluate].instance_of?(Array)
      name.evaluate.to_sym
    end
  end

  rule :name, /[^\=\[\]\s]+/ do
    def evaluate
      to_sym
    end
  end

  rule :any, /[^\n\=\[\];#]+/ do
    def evaluate
      to_sym
    end
  end

  rule :comment, any('#', ';'), /[^\n]+/ do
    def evaluate
      nil
    end
  end
end

class String
  def from_ini
    parser = INIHash.new
    result = parser.parse(self)
    line, column = BabelBridge::Tools.line_column(self, parser.failure_index)

    if result
      result.evaluate
      parser.result
    else
      error_line = self.split(/\n+/)[line - 1]
      puts "(\e[31m\e[1mSyntax\e[21m Failure\e[39m) on line #{line - 1} and column #{column}..."
    end
  end
end
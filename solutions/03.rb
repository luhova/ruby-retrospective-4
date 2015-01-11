module RBFS
  class File
    attr_accessor :data

    def initialize(object = nil)
      @data = object
    end

    def data_type
      case @data
        when String     then @data_type = :string
        when Numeric    then @data_type = :number
        when Symbol     then @data_type = :symbol
        when TrueClass  then @data_type = :boolean
        when FalseClass then @data_type = :boolean
        else                 @data_type = :nil
      end
    end

    def serialize
      "#{data_type}:#{@data}"
    end

    def self.parse(string_data)
      array = string_data.split(':', 2)
      case array[0]
        when "string"  then File.new(array[1])
        when "symbol"  then File.new(array[1].to_sym)
        when "number"  then File.new(array[1].to_f)
        when "boolean" then File.new(array[1] == 'true')
        else                File.new
      end
    end
  end

  class Directory
    def initialize
      @directory = Hash.new
    end

    def add_file(name, file)
      @directory[name] = file
    end

    def add_directory(name, directory = Directory.new)
      @directory[name] = directory
    end

    def [](name)
      @directory[name]
    end

    def files
      @directory.select do |key, value|
        value.is_a? File
      end
    end

    def directories
      @directory.select do |key, value|
        value.is_a? Directory
      end
    end

    def serialize
      string_data = "#{files.length}:"
      files.each do |key, value|
        string_data += "#{key}:#{value.serialize.length}:" + value.serialize
      end
      string_data += "#{directories.length}:"
      directories.each do |key, value|
        string_data += "#{key}:#{value.serialize.length}:" + value.serialize
      end
      string_data
    end
  end
end


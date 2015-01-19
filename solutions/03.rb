module RBFS
  class File
    attr_accessor :data

    def initialize(object = nil)
      @data = object
    end

    def data_type
      case @data
      when nil        then :nil
      when String     then :string
      when Numeric    then :number
      when Symbol     then :symbol
      else                 :boolean
      end
    end

    def serialize
      "#{data_type}:#{@data}"
    end

    def self.parse(string_data)
      data_type, data = string_data.split(':', 2)
      data = case data_type
               when 'string'  then data
               when 'symbol'  then data.to_sym
               when 'number'  then data.to_f
               when 'boolean' then data == 'true'
             end
      File.new(data)
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
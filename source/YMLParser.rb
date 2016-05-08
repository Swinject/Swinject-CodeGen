require "yaml"

class YMLParser
  def parse_YML(input_filename)
    YAML.load_file(input_filename)
  end
end

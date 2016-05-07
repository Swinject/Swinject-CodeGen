require 'yaml'

class YMLParser

  def parse_YML(input_filename)
    return YAML.load_file(input_filename)
  end

end

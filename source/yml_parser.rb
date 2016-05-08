require "yaml"

# class responsible for parsing from yaml
class YMLParser
  def parse_yml(input_filename)
    YAML.load_file(input_filename)
  end
end

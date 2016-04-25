require 'yaml'

class YMLParser

  def parseYML(inputFilename)
    return YAML.load_file(inputFilename)
  end

end

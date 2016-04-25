require 'yaml'

class YMLSerializer

  def serializeHashToYML(hash, outputFilename)
    File.open(outputFilename, 'w') { |file| file.write(hash.to_yaml) }
  end

end

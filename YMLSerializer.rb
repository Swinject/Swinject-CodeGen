require 'yaml'

class YMLSerializer

  def serializeHashToYML(hash, outputFilename)
    code = hash.to_yaml

    if outputFilename.nil?
      puts code
    else
      File.open(outputFilename, 'w') do |fileToWriteTo|
        fileToWriteTo.puts code
      end
    end
  end

end

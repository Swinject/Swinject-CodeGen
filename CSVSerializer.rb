require 'erb'
require 'set'

class CSVSerializer
  def templatesFolder
    File.expand_path(File.dirname(__FILE__))
  end

  def serializeHashToCSV(hash, outputFilename)
    @CSVcontentArray = hash[:DEFINITIONS]
    @CSVdependencies = hash[:DEPENDENCIES]

    fileToWriteTo = File.open(outputFilename, 'w')
    fileToWriteTo.puts ERB.new(File.read("#{templatesFolder}/csv.erb"), nil, "-").result
    fileToWriteTo.close
  end

end

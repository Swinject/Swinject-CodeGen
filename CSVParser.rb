class CSVParser

  def parseCSV(inputFilename)
    returnHash = {
      :DEPENDENCIES => [],
      :DEFINITIONS => []
    }

    f = File.open(inputFilename)

    f.each_line do |line|
      if line.nil? || line.chomp.empty?
        # ignores empty lines
      elsif line.start_with?("#")
         # detect command
        if(line.start_with?("#ADD_DEPENDENCY "))
          returnHash[:DEPENDENCIES].push(line.split(" ")[1])
        elsif(line.start_with?("# ADD_DEPENDENCY "))
          returnHash[:DEPENDENCIES].push(line.split(" ")[2])
        end
      elsif line.start_with?("//")
          # ignores comments
      else
          array = line.split(";").map { |a| a.strip }
          arguments = array[3..-1]
          argumentHashes = nil
          unless arguments.nil?
              arguments.reject { |a| a.empty? }
              argumentHashes = arguments.map do |a|
                  hash = nil
                  if(a.include?(":"))
                      hash = {
                          :argumentName => a.split(":").first.strip,
                          :argumentType => a.split(":").last.strip
                      }
                  else
                      hash = {
                          :argumentName => a.downcase,
                          :argumentType => a
                      }
                  end
                  hash
              end
          end

          baseClass = array[0]

          targetClass = array[1]

          if targetClass.nil?
            targetClass = baseClass
          end

          targetClassName = targetClass.gsub("<", "").gsub(">", "").gsub(".", "")

          name = array[2]

          hash = {
              :baseClass => baseClass,
              :targetClass => targetClass,
              :targetClassName => targetClassName,
              :name => name,
              :arguments => argumentHashes
          }

          returnHash[:DEFINITIONS].push hash
        end
    end
    return returnHash
  end

end

class CSVParser

  def parse_CSV(input_filename)
    result_hash = {
      :DEPENDENCIES => [],
      :DEFINITIONS => []
    }

    f = File.open(input_filename)

    f.each_line do |line|
      if line.nil? || line.chomp.empty?
        # ignores empty lines
      elsif line.start_with?("#")
        # detect command
        if(line.start_with?("#ADD_DEPENDENCY "))
          result_hash[:DEPENDENCIES].push(line.split(" ")[1])
        elsif(line.start_with?("# ADD_DEPENDENCY "))
          result_hash[:DEPENDENCIES].push(line.split(" ")[2])
        end
      elsif line.start_with?("//")
        # ignores comments
      else
        array = line.split(";").map { |a| a.strip }
        arguments = array[3..-1]
        argument_hashes = nil
        unless arguments.nil?
          arguments.reject { |a| a.empty? }
          argument_hashes = arguments.map do |a|
            hash = nil
            if(a.include?(":"))
              hash = {
                :argument_name => a.split(":").first.strip,
                :argument_type => a.split(":").last.strip
              }
            else
              hash = {
                :argument_name => a.downcase,
                :argument_type => a
              }
            end
            hash
          end
        end

        base_class = array[0]
        target_class = array[1] || base_class
        target_class_name = target_class.gsub("<", "").gsub(">", "").gsub(".", "")
        name = array[2]

        hash = {
          :base_class => base_class,
          :target_class => target_class,
          :target_class_name => target_class_name,
          :name => name,
          :arguments => argument_hashes
        }

        result_hash[:DEFINITIONS].push hash
      end
    end
    return result_hash
  end

end

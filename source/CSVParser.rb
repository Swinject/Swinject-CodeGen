class CSVParser

  def parse_CSV(input_filename)
    result_hash = {
      :HEADERS.to_s => [],
      :DEFINITIONS.to_s => []
    }

    f = File.open(input_filename)

    f.each_line do |line|
      if line.nil? || line.chomp.empty?
        # ignores empty lines
      elsif line.start_with?("#")
        # detect command
        if(line.start_with?("#= "))
          result_hash[:HEADERS.to_s].push(line.split(" ")[1..-1].join(" "))
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
                :argument_name.to_s => a.split(":").first.strip,
                :argument_type.to_s => a.split(":").last.strip
              }
            else
              hash = {
                :argument_name.to_s => a.downcase,
                :argument_type.to_s => a
              }
            end
            hash
          end
        end

        service = array[0]
        component = array[1] || service
        name = array[2]

        hash = {
          :service.to_s => service,
          :component.to_s => component,
          :name.to_s => name,
          :arguments.to_s => argument_hashes
        }

        result_hash[:DEFINITIONS.to_s].push hash
      end
    end
    return result_hash
  end

end

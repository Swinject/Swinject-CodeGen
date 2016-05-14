# responsible for parsing the csv files
class CSVParser
  def parse_csv(input_filename)
    result_hash = {
      DEPENDENCIES: [],
      DEFINITIONS: []
    }

    f = File.open(input_filename)

    f.each_line do |line|
      if line.nil? || line.chomp.empty?
        # ignores empty lines
      elsif line.start_with?("#")
        # detect command
        if line.start_with?("#ADD_DEPENDENCY ")
          result_hash[:DEPENDENCIES].push(line.split(" ")[1])
        elsif line.start_with?("# ADD_DEPENDENCY ")
          result_hash[:DEPENDENCIES].push(line.split(" ")[2])
        end
      elsif line.start_with?("//")
        # ignores comments
      else
        array = line.split(";").map(&:strip)
        arguments = array[3..-1]
        arguments = arguments.reject { |a| a.empty? } unless arguments.nil?
        argument_hashes = nil
        unless arguments.nil?
          arguments.reject(&:empty?)
          argument_hashes = arguments.map do |a|
            hash = nil
            if a.include?(":")
              hash = {
                argument_name: a.split(":").first.strip,
                argument_type: a.split(":").last.strip
              }
            else
              hash = {
                argument_name: a.downcase,
                argument_type: a
              }
            end
            hash
          end
        end

        service = array[0]
        component = array[1] || service
        name = array[2]

        hash = {
          service: service,
          component: component,
          name: name,
          arguments: argument_hashes
        }

        result_hash[:DEFINITIONS].push hash
      end
    end
    result_hash
  end
end

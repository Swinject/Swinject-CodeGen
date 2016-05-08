require "yaml"

class YMLSerializer
  def serialize_hash_to_YML(hash, output_filename)
    code = hash.to_yaml

    if output_filename.nil?
      puts code
    else
      File.open(output_filename, "w") do |file_to_write_to|
        file_to_write_to.puts code
      end
    end
  end
end

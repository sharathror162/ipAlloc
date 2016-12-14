require 'csv'

class CsvLoader 

  def load_from_csv!(ip_add, file_path)
    CSV.foreach(file_path) do |row|
      return row[2] if row[1] == ip_add
    end
  end

  def write_to_csv!(ip_add, device, file_path)
  	CSV.open(file_path, "a+") do |row|
  		row << ["1.2.0.0/16", ip_add, device]
		end  
  end

  def read_from_csv!(file_path)
  	CSV.read(file_path)
  end

end




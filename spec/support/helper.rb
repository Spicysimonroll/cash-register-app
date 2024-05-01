require 'csv'

class Helper
  def self.write_csv(file, data)
    CSV.open(file, 'w') { |csv| data.each { |row| csv << row } }
  end
end

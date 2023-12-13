# app/services/csv_import_service.rb
require 'csv'

class CsvImportService
  def initialize(file_path, model_class)
    @file_path = file_path
    @model_class = model_class
  end

  
  def import
    CSV.foreach(@file_path, headers: true) do |row|
      record_attributes = row.to_hash
      existing_record = @model_class.find_by(reference: record_attributes['reference'])

      if existing_record
        existing_record.update(record_attributes)
      else
        @model_class.create!(record_attributes)
      end
    end
  end
end

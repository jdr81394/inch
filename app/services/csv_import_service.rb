require 'csv'

class CsvImportService
  def initialize(file_path, model_class)
    @file_path = file_path
    @model_class = model_class
  end

  # I chose to have 2 seperate routes to distinguish 
  # between it being manual and not manual
  def manualImport
    import_helper(true)
  end

  def import
    import_helper(false)
  end

  private 
  def import_helper(isManual)
    CSV.foreach(@file_path, headers: true) do |row|
      record_attributes = row.to_hash
      reference_value = record_attributes['reference']
      # Get the most recently created record that has this reference to do attribute comparisons with
      existing_record = @model_class.where(reference: reference_value).order(created_at: :desc).first

      if existing_record
        # Update only if the new value has never been a value of that field
        update_attributes = {}
        # If it is not manual, then we need to check if the attributes existed before
        if isManual == false
          record_attributes.each do |key, value|
            if allowed_to_update?(existing_record, key, value)
              update_attributes[key] = value
            else
              # Do not allow it to be updated and simply use the last value.
              update_attributes[key] = existing_record[key]
            end
          end
        else 
          # If it is manual, simply just copy these attributes
          update_attributes = record_attributes
        end

        # Create a new record and save
        new_record = @model_class.new(update_attributes)
        new_record.save!
      else
        # Create a new record if it doesn't exist
        @model_class.create!(record_attributes)
      end
    end
  end

  private
  def allowed_to_update?(existing_record, attribute, new_value)
    if existing_record.is_a?(Person)
      case attribute
      when 'email', 'home_phone_number', 'mobile_phone_number', 'address'
        # Get all the records with the same reference
        all_records = @model_class.where(reference: existing_record['reference'])

        # Check if the new value has never been a value of that field
        all_records.each do |record|
          # If there is a record that had this value, then return false and do not allow it to be updated.
          if record[attribute] == new_value
            return false
          end 
        end
        true
      else
        # Allow updates for other attributes
        return true 
      end

    elsif existing_record.is_a?(Building)
      case attribute
      when 'manager_name'
        # Check if the new value has never been a value of that field
        all_records = @model_class.where(reference: existing_record['reference'])

        all_records.each do |record|
          puts "new value #{new_value} vs the preexisting record: #{record[attribute]}"
          if record[attribute] == new_value
            return false
          end 
        end
        true
      else
        return true # Allow updates for other attributes
      end
    end

  end


end

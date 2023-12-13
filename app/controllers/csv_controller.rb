class CsvController < ApplicationController


    def import_csv_manually
        file = params[:csv_file]
        file_name = file.original_filename

        if file_name.include?("building")
            CsvImportService.new(file, Building).manualImport
        
        elsif file_name.include?("people") || file_name.include?("person") 
            CsvImportService.new(file, Person).manualImport        
        else 
            puts "There was no model matching: #{file_name}"
        end 

        redirect_to root_path, notice: 'Manual CSV import completed successfully.'
    end

    def import_csv
        file = params[:csv_file]
        file_name = file.original_filename

        if file_name.include?("building")
            CsvImportService.new(file, Building).import
        
        elsif file_name.include?("people") || file_name.include?("person") 
            CsvImportService.new(file, Person).import        
        else 
            puts "There was no model matching: #{file_name}"
        end 

        redirect_to root_path, notice: 'CSV import completed successfully.'
    end
end

class CsvController < ApplicationController
    def import_csv
        # file_path = ''      # add in this path
        file = params[:csv_file]
        file_name = file.original_filename

        puts "Original Filename: #{file_name}"

        # Remove the ".csv" extension
        filename_without_extension = File.basename(file_name, File.extname(file_name)).downcase

        # Now you can use the filename without the ".csv" extension
        puts "Filename without extension: #{filename_without_extension}"

        if filename_without_extension == "building" ||  filename_without_extension == "buildings"
            puts "In building"
            CsvImportService.new(file, Building).import
        
        elsif filename_without_extension == "people" 
            puts "In person"
            CsvImportService.new(file, Person).import
        
        else 
            puts "There was no model matching: #{filename_without_extension}"
        end 

        #  message
        redirect_to root_path, notice: 'CSV import completed successfully.'

    end
end

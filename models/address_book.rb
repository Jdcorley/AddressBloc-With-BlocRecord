require_relative 'entry'
require 'csv'
require 'bloc_record/base'

class AddressBook < BlocRecord::Base 
  # Initialize
  def initialize(options={})
    super 
    @entries = []
  end
  # Remove Entry
  def remove_entry(name, phone_number, email)
    delete_entry = nil

    @entries.each do |entry|
      if name == entry.name && phone_number == entry.phone_number && email == entry.email
        delete_entry = entry
      end
    end
    @entries.delete(delete_entry)
  end
  # Add entry
  def add_entry(name, phone_number, email)
    Entry.create(name: name, phone_number: phone_number, email: email, address_book_id: self.id)
  end

  def entries
    Entry.where(address_book_id: self.id)
  end

  def find_entry(name)
    Entry.where(name: name, address_book_id: self.id).first
  end
  # Import CSVs
  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)

    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end
    # Search AddressBook for a specific entry by name iterativly
  def iterative_search(name)
    @entries.each do |entry|
      unless entry.name != name
        return entry
      end
    end 
      nil
  end
end 
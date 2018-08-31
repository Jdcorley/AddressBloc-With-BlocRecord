require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.first
  end

  def main_menu
    puts "#{@address_book.name} Address Book Selected\n#{@address_book.entries.count} entries"
    puts '0 - Switch AddressBook'
    puts '1 - View all entries'
    puts '2 - Create an entry'
    puts '3 - Search for an entry'
    puts '4 - View entry Number n'
    puts '5 - Import entries from a CSV'
    puts '6 - Exit'
    puts '7 - Nuke all entries'
    print 'Enter your selection: '

    selection = gets.to_i

    case selection
    when 0
      system 'clear'
      select_address_book_menu
      main_menu
    when 1
      system 'clear'
      view_all_entries
      main_menu
    when 2
      system 'clear'
      create_entry
      main_menu
    when 3
      system 'clear'
      search_entries
      main_menu
    when 4
      system 'clear'
      entry_n_submenu
      main_menu
    when 5
      system 'clear'
      read_csv
      main_menu
    when 6
      puts 'Good-bye!'

      exit(0)
    when 7
      system 'clear'
      nuke
      main_menu
    else
      system 'clear'
      puts 'Sorry, that is not a valid input'
      main_menu
    end
  end

  def select_address_book_menu
    puts 'Select an Address Book:'
    AddressBook.all.each_with_index do |address_book, index|
      puts "#{index} - #{address_book.name}"
    end

    index = gets.chomp.to_i

    @address_book = AddressBook.find(index + 1)
    system 'clear'
    return if @address_book
    puts 'Please select a valid index'
    select_address_book_menu
  end

  def view_all_entries
    @address_book.entries.each do |entry|
      system 'clear'
      puts entry.to_s

      entry_submenu(entry)
    end

    system 'clear'
    puts 'End of entries'
  end

  def create_entry
    system 'clear'
    puts 'New AddressBloc Entry'
    print 'Name: '
    name = gets.chomp
    print 'Phone number: '
    phone = gets.chomp
    print 'Email: '
    email = gets.chomp

    @address_book.add_entry(name, phone, email)

    system 'clear'
    puts 'New entry created'
  end

  def search_entries
    print 'Search by name: '
    name = gets.chomp

    match = @address_book.find_entry(name)
    system 'clear'

    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end

  def nuke
    puts 'Are you sure you want to nuke all entries?'
    print 'Enter yes or no: '
    confirm = gets.chomp
    if confirm == 'yes'
      address_book.entries.clear
    elsif confirm == 'no'
      main_menu
    else
      puts 'Not a valid entry.'
      nuke
    end
  end

  def search_submenu(entry)
    puts "\nd - delete entry"
    puts 'e - edit this entry'
    puts 'm - return to main menu'

    selection = gets.chomp

    case selection
    when 'd'
      system 'clear'
      delete_entry(entry)
      main_menu
    when 'e'
      edit_entry(entry)
      system 'clear'
      main_menu
    else
      system 'clear'
      puts "#{selection} is not a valid input"
      puts entry.to_s
      search_submenu(entry)
      end
      end

  def entry_n_submenu
    system 'clear'
    print 'Entry Number to view: '
    selection = gets.chomp.to_i - 1

    if selection < @address_book.entries.count
      puts @address_book.entries[selection]
      puts 'Press enter to return to Main Menu.'
      gets.chomp
      system 'clear'
    else
      puts "#{selection} is an invalid input."
      entry_n_submenu
    end
  end

  def read_csv
    print 'Enter CSV file to import: '
    file_name = gets.chomp

    if file_name.empty?
      system 'clear'
      puts 'No CSV file read'
      main_menu
    end

    begin
      entry_count = address_book.import_from_csv(file_name).count
      system 'clear'
      puts "#{entry_count} new entries added from #{file_name}."
    rescue StandardError
      puts "#{file_name} is not valid CSV file, please enter the name of a valid CSV file."
      read_csv
    end
  end

  def delete_entry(entry)
    address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted."
  end

  def edit_entry(entry)
    updates = {}
    print 'Updated name: '
    name = gets.chomp
    updates[:name] = name unless name.empty?
    print'Updated phone number: '
    phone_number = gets.chomp
    updates[:phone_number] = phone_number unless phone_number.empty?
    print 'Update email: '
    email = gets.chomp
    updates[:email] = email unless email.empty?
    system 'clear'
    puts 'Updated entry:'
    puts Entry.find(entry.id)
  end

  def entry_submenu(entry)
    puts 'n - next entry'
    puts 'd - delete entry'
    puts 'e - edit this entry'
    puts 'm - return to main menu'

    selection = gets.chomp

    case selection

    when 'n'
    when 'd'
      delete_entry(entry)
    when 'e'
      edit_entry(entry)
      entry_submenu(entry)
    when 'm'
      system 'clear'
      main_menu
    else
      system 'clear'
      puts "#{selection} is not a valid input"
      entry_submenu(entry)
    end
  end
end

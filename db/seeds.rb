# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'


User.create!(name: 'David Thomason', email: 'david@example.com', password: 'foobar', password_confirmation: 'foobar')


# Load the transaction categories
CSV.foreach('db/transaction_categories.csv', headers: true) do |row|
  TransactionCategory.create!(id: row[1], name: row[0])
end
puts "Loaded #{TransactionCategory.count} transaction categories."


puts 'Loading the customers and transactions...'
customer = Customer.new
CSV.foreach('db/transactions.csv', headers: true) do |row|
  
  if row['twitter_id']
    
    # If we've encountered a new user, add it to the database
    if row['id'].to_i != customer.id
      customer.save! if customer.id
      customer = Customer.new
      Customer.attribute_names.each do |attr_name|
        customer[attr_name] = row[attr_name]
      end
      customer.user = User.new(name:     row['name'], email: row['name'].downcase.split.first+'@example.com',
                               password: 'password', password_confirmation: 'password')
      puts "New customer with Twitter ID #{customer.twitter_id}"
    end
    
    # add the transaction
    customer.transactions.build(customer_id:             row['id'],
                                date:                    row['transaction_date'],
                                amount:                  row['transaction_amount'],
                                transaction_category_id: row['transaction_category_code'])
  
  end

end
puts "Loaded #{Customer.count} customers and #{Transaction.count} transactions."


# Load the twitter personalities
CSV.foreach('db/twitter_personalities.csv', headers: true) do |row|
  tp = TwitterPersonality.new(row.to_hash.slice('personality', 'values', 'needs'))
  tp.customer = Customer.find_by_twitter_id row['username']
  puts "#{row['username']} : #{tp.customer.user.name}" if tp.customer
  tp.save
end

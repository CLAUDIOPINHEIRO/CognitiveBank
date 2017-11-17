require 'rails_helper'

feature 'Administrate Customers' do
  
  background do

    # Visit home page and click 'Log in'
    visit '/'
    expect_home_page
    
    # Fill in log in credentials
    login('david@example.com', 'password')

    expect_admin_panel
    
  end

  scenario 'Create Sally' do
    
    # Create first Sally
    create_sally

    # Expect her profile
    expect(page).to have_text "Sally's Profile:"
    expect(page).to have_text 'sally@example.com'
    expect_sally_profile
    
    # Go back to admin
    click_link 'x_admin_link'
    expect_admin_panel

    # Create second Sally
    create_sally

    # Expect her profile
    expect(page).to have_text "Sally's Profile:"
    expect(page).to have_text 'sally1@example.com'
    expect_sally_profile
    
    click_link 'Account'
    click_link 'Log out'
    expect_home_page
    
    login('sally@example.com', 'password')

    # Expect the customer dashboard
    expect(page).to have_text 'Welcome back, Sally!'
    expect(page).to have_text 'Cognitive Traveler Rewards Card'
    expect(page).to have_text 'Current Balance'
    expect(page).to have_text 'Current Miles'
    expect(page).to have_text 'Last Statement Balance:'
    
    expect(page).to have_text 'Transactions'
    expect(page).to have_text '2016-12-29	Transportation'
    expect(page).to have_text '2016-12-22	Transportation'
    expect(page).to have_text '2016-12-19	Supermarkets'
    expect(page).to have_text 'Last Statement Balance:'

  end
  
end

def expect_home_page
  expect(page).to have_text 'Cognitive Bank'
  expect(page).to have_text 'Log in'
end

def login(email, password)
  click_link 'Log in'
  within('h1') { expect(page).to have_text 'Log in' }
  within 'form' do
    expect(page).to have_text 'Email'
    expect(page).to have_text 'Password'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end

def expect_admin_panel
  expect(page).to have_text 'Admin Panel'
  expect(page).to have_text 'Welcome, David!'
  expect(page).to have_text 'You are logged in as administrator'

  expect(page).to have_text 'Customers:'
  expect(page).to have_text 'Name Churn Prediction: Churn Probability: Scoring Time: Profile'
  expect(page).to have_text 'Bruce View Profile'

  expect(page).to have_text 'Machine Learning Services:'
  expect(page).to have_text 'Name Type Hostname Deployment Actions'
  expect(page).to have_link 'New Machine Learning Service'
end

def create_sally
  
  click_link 'New Customer'
  
  # Required fields
  expect(page).to have_text 'Name*: Twitter Handle*: Age*: Activity*:'
  expect(page).to have_text 'Education Level*:'
  expect(page).to have_select 'Education Level*:',
                              with_options: ['High School Degree', "Associate's Degree", "Bachelor's Degree", "Master's Degree", "Doctor's Degree"]
  expect(page).to have_select 'Gender*:', with_options: ['Male', 'Female']
  expect(page).to have_text 'State*: Negative Tweets*: Income*:'
  
  # Optional fields
  expect(page).to have_text 'Investment: Annual Spending: Annual Transactions:'
  expect(page).to have_text 'Average Daily Transactions: Average Transaction Amount:'
  expect(page).to have_select 'Nationality:', with_options: ['United States ($)', 'India (₹)']
  
  # Fill in required fields
  fill_in 'Name', with: 'Sally'
  fill_in 'Twitter Handle', with: 'sally_may_22'
  fill_in 'Age', with: '22'
  fill_in 'Activity', with: '3'
  select  "Doctor's Degree", from: 'Education Level'
  select  'Female', from: 'Gender'
  fill_in 'State', with: 'FL'
  fill_in 'Negative Tweets', with: '3'
  fill_in 'Income', with: '130500'
  
  click_button 'Create Customer'

end

def expect_sally_profile
  
  expect(page).to have_text 'Gender: Female'
  expect(page).to have_text 'Age: 22'
  expect(page).to have_text 'State: FL'
  expect(page).to have_text 'Education Level: Doctorate'
  expect(page).to have_text 'Income: $ 130,500.00'
  expect(page).to have_text 'Investment:'
  expect(page).to have_text 'Annual Spending:'
  expect(page).to have_text 'Annual Transactions:'
  expect(page).to have_text 'Average Daily Transactions:'
  expect(page).to have_text 'Average Transaction Amount:'
  
  expect(page).to have_text 'Twitter Profile:'
  expect(page).to have_text '@sally_may_22'
  expect(page).to have_text 'Negative Finance-Related Tweets: 3'
  expect(page).to have_text 'Keywords'
  expect(page).to have_text 'Sentiment'
  expect(page).to have_text 'foreign exchange fees 0%'
  
  expect(page).to have_text 'Personality Insights:'
  expect(page).to have_text 'Needs:	Practicality'
  expect(page).to have_text 'Values: Self-transcendence'
  
end
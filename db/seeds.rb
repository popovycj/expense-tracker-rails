categories = ["Food", "Housing", "Transportation", "Entertainment", "Healthcare"]

categories.each do |name|
  Category.create!(name: name)
  puts "Created category: #{name}"
end

# Create some users
10.times do |i|
  User.create!(
    email: "user#{i+1}@example.com",
    password: "password"
  )

  puts "Created user: user#{i+1}@example.com"
end

# Create expenses for each user with random categories, descriptions, amounts, and visibilities
User.all.each do |user|
  10.times do
    expense = user.expenses.create!(
      category: Category.all.sample,
      description: Faker::Lorem.sentence(word_count: 3),
      amount: rand(10.0..100.0).round(2),
      visibility: rand(0..1),
      created_at: Time.zone.local(2023, rand(1..2), rand(1..30), rand(0..23), rand(0..59), rand(0..59))
    )

    puts "Created expense: #{expense.description} (user: #{user.email}, category: #{expense.category.name})"
  end
end

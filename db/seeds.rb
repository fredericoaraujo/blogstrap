require 'faker'

p 'Início'
Article.delete_all

amount_user = User.all.count

Category.all.each do |category| 
    30.times do
        user_id = rand(1..amount_user)
        amount = rand(30)
        amount.times do
            Article.create!(
                title: Faker::Quote.famous_last_words,
                body: Faker::Lorem.paragraph(sentence_count: rand(10..1_000)),
                user_id: user_id,
                category: category,
                created_at: rand(365).days.ago
            )
        end
    end
end

p 'Fim...'
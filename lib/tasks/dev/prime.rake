if Rails.env.development? || Rails.env.test?
  require 'factory_bot'

  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      include FactoryBot::Syntax::Methods

      15.times do
        profile = [:admin, :normal].sample
        create(:user, profile: profile)
      end

      system_requirements = []
      ['Basic', 'Intermediate', 'Advanced'].each do |sr_name|
        system_requirements << create(:system_requirement, name: sr_name)
      end

      15.times do
        coupon_status = [:active, :inactive].sample
        create(:coupon, coupon_status: coupon_status)
      end

      categories = []
      25.times do
        categories << create(:category, name: Faker::Game.unique.genre)
      end

      30.times do
        game_name = Faker::Game.unique.title
        availability = [:available, :out_of_stock].sample
        categories_count = rand(0..3)
        game_categories_ids = []
        categories_count.times { game_categories_ids << Category.all.sample.id }
        game = create(:game, system_requirement: system_requirements.sample)
        create(:product, name: game_name, product_status: availability,
               category_ids: game_categories_ids, productable: game)
      end

      50.times do
        game = Game.all[0..5].sample
        status = License.license_statuses.keys.sample
        platform = License.license_platforms.keys.sample

        if status != "pending_creation"
          create(:license, license_status: status, license_platform: platform, game: game)
        else
          create(:license, license_status: status, license_platform: platform, game: game, key: nil)
        end
      end
    end
  end
end
namespace :users do
  namespace :db do
    desc "runs db:migrate on each user's private schema"
    task migrate: :environment do
      verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migration.verbose = verbose

      User.all.each do |user|
        puts "migrating user #{user.id}"
        PgTools.set_search_path user.id, false
        version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
        ActiveRecord::Migrator.migrate("db/migrate/", version)
      end
    end
  end
end

namespace "Docit" do
  namespace "seed" do

    desc "create admin user"
      task :create_admin_user => :environment do
        users = [
          {:email=> 'admin@docitamerica.com',
            :first_name => 'Super',
            :last_name => 'Admin',
            :password => 'admin123',
            :password_confirmation => 'admin123',
            :assignments_attributes => [{:role_id => 1}]
          }
        ]
        users.each do |rs|
          unless User.find_by_email(rs[:email])
            newuser = User.new
            newuser.assignments.build
            newuser = User.new(rs)
            newuser.skip_confirmation!
            newuser.save!
            puts "User created with email - #{rs[:email]}"
          end
        end
        puts ""
      end
      
  end  #u
end  #docit

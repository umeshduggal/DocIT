namespace "Docit" do
  namespace "seed" do

    desc "creates record status constants"
      task :role => :environment do
        roles = [
          {:id=> '1',
           :name=> 'Admin'},
          {:id=> '2',
           :name=> 'Doctor'
           },
          {:id=> '3',
           :name=> 'IntendedRecipient'
           }
        ]

        roles.each do |rs|
          unless Role.find_by_name(rs[:name])
            sql="insert into roles (id, name,created_at,updated_at) values (%s,'%s','%s','%s')" % [ rs[:id], rs[:name],Time.zone.now,Time.zone.now ]
            puts "Creating Role: #{rs[:name]}"
            
            ActiveRecord::Base.connection.execute sql
          end
        end
        puts ""
      end
      
    task :title => :environment do
        titles = [
          {:name=> 'Dr'},
          {:name=> 'Nurse Practitioner'},
          {:name=> 'Physician Assistant'},
          {:name=> 'Mr'},
          {:name=> 'Mrs'},
          {:name=> 'Ms'},
          {:name=> 'Attorney'}
        ]

        titles.each do |t|
          unless Title.find_by_name(t[:name])
            Title.create!(:name => t[:name])
            puts "Creating Title: #{t[:name]}"
          end
        end
        puts ""
      end
      
    task :consultation_type => :environment do
        consulations = [
          {:id => 1, :description=> 'How much will you charge for a consultation less than 5 minutes ( CPT 99499)',:lower_limit => 0, :upper_limit=> 5},
          {:id => 2, :description=> 'How much will you charge for a consultation 5-10 minutes ( CPT 99441)',:lower_limit => 5, :upper_limit=> 10},
          {:id => 3, :description=> 'How much will you charge for a consultation 10-20 minutes (CPT 99442)',:lower_limit => 10, :upper_limit=> 20},
          {:id => 4, :description=> 'How much will you charge for a consultation 20-30 minutes (CPT 99443)',:lower_limit => 20, :upper_limit=> 30},
          {:id => 5, :description=> 'How much will you charge for a consultation greater than 30 minutes( CPT 99499)',:lower_limit => 30,:upper_limit => 'null'},
        ]

        consulations.each do |c|
          unless ConsultationType.find_by_id(c[:id])
            sql="insert into consultation_types(id, description, lower_limit, upper_limit,created_at,updated_at) values (%s,'%s',%s,%s,'%s','%s')" % [ c[:id], c[:description],c[:lower_limit],c[:upper_limit],Time.zone.now, Time.zone.now ]
            puts "Creating consultation type: #{c[:id]}"
            ActiveRecord::Base.connection.execute sql
          end
        end
        puts ""
      end

  end  #u
end  #docit

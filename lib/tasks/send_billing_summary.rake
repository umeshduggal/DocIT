namespace :docit do
  task :send_billing_summary => :environment do
    File.open("/home/umesh/docit/DocIT/log/rake.log", "w+") do |f|
      f.write("Starting Cron task at " + Time.zone.now.to_i.to_s)
    end
    DATETIME_CONST = Time.zone.now.to_i.to_s
    CallLog.where("conversation_call_duration is not null").each do |cl|
        if cl.billing_summary.nil?
          user = cl.user
          consultation_type_id = nil
          ConsultationType.all.each do |ct|
            upper_limit_sec = 0
            lower_limit_sec = ct.lower_limit.to_i * 60 unless ct.lower_limit.nil?
            upper_limit_sec = ct.upper_limit.to_i * 60 unless ct.upper_limit.nil?
            puts "upper limit #{upper_limit_sec}"
            if cl.conversation_call_duration.to_i < upper_limit_sec
              consultation_type_id = ct.id
              break
            elsif cl.conversation_call_duration.to_i <= lower_limit_sec
              consultation_type_id = ct.id
              break
            end
          end
          consultation_charge = user.consultation_charges.where("consultation_type_id = #{consultation_type_id}").first rescue ""
          unless consultation_charge.blank?
            BillingSummary.create!(:call_log_id => cl.id, :billable_ammount => consultation_charge.charges,:datetime_constant=>DATETIME_CONST)
            puts "Billing summary generated for call log Id- #{cl.id}"
          end
#        else
#          puts "Billing summary already generated for call log Id #{cl.id}"
        end
    end
    User.all.each do |u|
      if u.has_role? :doctor
        u.intended_recipients.each do |ir|
            if ir.registered?
              UserMailer.send_billing_summary(u, ir, DATETIME_CONST).deliver
              puts "sent mail to #{ir.email} successfully"
            end
          end
      end
    end
  end
end # :nightly

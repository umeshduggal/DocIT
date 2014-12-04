#!/bin/bash
cd /home/ubuntu/DocIT
#cd /media/sf_docit/DocIT
#source /usr/local/rvm/environments/ruby-1.9.3-p484
source /home/ubuntu/.rvm/environments/ruby-1.9.3-p484
rake RAILS_ENV=production docit:send_billing_summary
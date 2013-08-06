require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

# require "#{ENV['GEM_HOME']}/gems/aws-flow-1.0.0/lib/aws/decider/worker.rb"
require "#{ENV['GEM_HOME']}/gems/aws-flow-1.0.0/lib/aws/decider.rb"
require "#{Rails.root}/lib/scrape_activity.rb"
require "#{Rails.root}/lib/scrape_workflow.rb"

namespace :swf do
  desc 'Start activity worker'
  task :activity => :environment do
    swf, domain = swf_domain
    activity_worker = AWS::Flow::ActivityWorker.new(swf.client, domain, SWF_ACTIVITY_TASK_LIST, ScrapeActivity) { {:use_forking => false} }
    activity_worker.start
  end

  desc 'Start workflow worker'
  task :workflow => :environment do
    swf, domain = swf_domain
    worker = AWS::Flow::WorkflowWorker.new(swf.client, domain, SWF_WORKFLOW_TASK_LIST, ScrapeWorkflow)
    worker.start
  end

  desc 'Queue activities'
  task :scrape => :environment do
    swf, domain = swf_domain
    my_workflow_client = AWS::Flow::workflow_client(swf.client, domain) { {:from_class => "ScrapeWorkflow"} }

    Product.all.each do |product|
      $workflow_execution = my_workflow_client.start_execution(product.asin)
    end
  end  
end

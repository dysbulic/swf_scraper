class Scrape
  def init
    require 'aws/decider'

    $BOOKING_DOMAIN = "Scrape"
    config_file = File.open('../config/aws.yml') { |f| f.read }
    AWS.config(YAML.load(config_file))
    
    @swf = AWS::SimpleWorkflow.new
    begin
      @domain = @swf.domains.create($BOOKING_DOMAIN, "10")
    rescue AWS::SimpleWorkflow::Errors::DomainAlreadyExistsFault => e
      @domain = @swf.domains[$BOOKING_DOMAIN]
    end
    
    $swf, $domain = @swf, @domain #globalize them for use in tests
    
    # Set up the workflow/activity worker
    $workflow_task_list = "booking_workflow_task_list"
    $activity_task_list = "booking_activity_task_list"
  end

  
end

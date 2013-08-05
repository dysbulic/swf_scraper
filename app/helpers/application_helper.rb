module ApplicationHelper
  def swf_domain
    config_file = File.open("#{Rails.root}/config/aws.yml") { |f| f.read }
    AWS.config(YAML.load(config_file))

    @swf = AWS::SimpleWorkflow.new
    begin
      @domain = @swf.domains.create(SWF_DOMAIN, "10")
    rescue AWS::SimpleWorkflow::Errors::DomainAlreadyExistsFault => e
      @domain = @swf.domains[SWF_DOMAIN]
    end
    
    return @swf, @domain
  end
end

##
# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#  http://aws.amazon.com/apache2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
##

require_relative './utils'
require_relative 'scrape_activity'

class ScrapeWorkflow
  extend AWS::Flow::Workflows

  workflow :queue_scrape do
    {
      :version => "1.0",
      :task_list => $workflow_task_list,
      :execution_start_to_close_timeout => 120,
    }
  end

  activity_client(:activity){ {:from_class => "ScrapeActivity"} }

  def queue_scrape(asin)
    scrape_future = Future.new.set
    scrape_future = activity.send_async(:scrape, asin) if asin
    # wait_for_all(scrape_future)
  end
end

worker = AWS::Flow::WorkflowWorker.new($swf.client, $domain, $workflow_task_list, ScrapeWorkflow)
worker.start if __FILE__ == $0

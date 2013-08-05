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

require_relative 'utils'
require_relative "./hello_activity"

class HelloWorldWorkflow
  extend AWS::Flow::Workflows

  workflow :hello_workflow do
  {
    :version => "1", :execution_start_to_close_timeout => 3600, :task_list => $TASK_LIST
  }
  end

  activity_client(:activity) { {:from_class => "HelloWorldActivity"} }

  def hello_workflow(name)
    activity.hello_activity(name)
  end
end

worker = AWS::Flow::WorkflowWorker.new($SWF.client, $HELLOWORLD_DOMAIN, $TASK_LIST, HelloWorldWorkflow)
# Start the worker if this file is called directly from the command line.
worker.start if __FILE__ == $0

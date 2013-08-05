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

class HelloWorldActivity
  extend AWS::Flow::Activities

  activity :hello_activity do
    {
      :default_task_list => $TASK_LIST, :version => "my_first_activity",
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30
    }
  end

  def hello_activity(name)
    puts "Hello, #{name}!"
  end
end

activity_worker = AWS::Flow::ActivityWorker.new($SWF.client, $HELLOWORLD_DOMAIN, $TASK_LIST, HelloWorldActivity) { {:use_forking => false} }

# Start the worker if this file is called directly from the command line.
activity_worker.start if __FILE__ == $0

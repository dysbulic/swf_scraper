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

class BookingActivity
  extend AWS::Flow::Activities

  activity :reserve_car, :reserve_airline, :send_confirmation  do
    {
      :version => "1.0",
      :default_task_list => $activity_task_list,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end


  def reserve_car(requestId)
    puts "Reserving car for Request ID:#{requestId} \n"
  end

  def reserve_airline(requestId)
    puts "Reserving airline for Request ID: #{requestId} \n"
  end

  def send_confirmation(customerId)
    puts "Sending notification to customer #{customerId}"
  end

end


activity_worker = AWS::Flow::ActivityWorker.new($swf.client, $domain, $activity_task_list, BookingActivity) { {:use_forking => false} }
activity_worker.start if __FILE__ == $0

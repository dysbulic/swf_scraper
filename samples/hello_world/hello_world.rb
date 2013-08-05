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

require 'aws/decider'
require_relative 'utils'
require_relative 'hello_workflow'

# Get a workflow client to start the workflow
my_workflow_client = AWS::Flow.workflow_client($SWF.client, $HELLOWORLD_DOMAIN) do
  {:from_class => "HelloWorldWorkflow"}
end

puts "Starting an execution..."
workflow_execution = my_workflow_client.start_execution("AWS Flow Framework for Ruby")

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

# Kills the hello_world activity and workflow processes.
# Requires the gem: sys-proctable.
require 'sys/proctable'

processes = []

Sys::ProcTable.ps.each { |ps|
  if (ps.name == "ruby") && (ps.cmdline.include? "hello_") then
    puts "#{ps.pid} #{ps.cmdline}"
    processes << ps.pid
  end
}

if (processes.count > 0) then
  puts "Found #{processes.count} processes: #{processes}."
  puts "Should I kill them?"
  if (gets.downcase.start_with? "y") then
    processes.each { |pid|
      Process.kill 'KILL', pid
    }
    puts "done!"
  else
    puts "leaving them alone..."
  end
else
  puts "Found no running hello_world processes."
end

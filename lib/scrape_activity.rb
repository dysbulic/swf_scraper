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

class ScrapeActivity
  extend AWS::Flow::Activities

  activity :scrape  do
    {
      :version => "1.0",
      :default_task_list => SWF_ACTIVITY_TASK_LIST,
      :default_task_schedule_to_start_timeout => 30,
      :default_task_start_to_close_timeout => 30,
    }
  end


  def scrape(asin)
    begin
      url = "http://www.amazon.com/dp/" + asin
      response = HTTParty.get(URI.encode(url))
      doc = Nokogiri::HTML(response)

      price_div = doc.at_css('.priceLarge')
      price = (price_div.nil? or price_div.text[/[0-9\.,]+/].nil?) ? nil : price_div.text[/[0-9\.,]+/].gsub(/,/, '').to_f
      
      unless price
        price_div = doc.at_css('.a-color-price.a-size-large')
        price = (price_div.nil? or price_div.text[/[0-9\.,]+/].nil?) ? nil : price_div.text[/[0-9\.,]+/].gsub(/,/, '').to_f
      end

      if price
        product = Product.find_by_asin(asin)
        product.records.create( price: price )
      end

      puts "Scraped: #{asin}: #{price}"
    rescue => e
      puts "Error: #{e.message}"
    end
  end
end

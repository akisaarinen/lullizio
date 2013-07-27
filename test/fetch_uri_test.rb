# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'fetch_uri.rb'

class TestFetchUri < Test::Unit::TestCase
  context "Fetching URI with get" do
    should "fetch an iltalehti uri" do
      reply = fetch_uri("http://www.iltalehti.fi/ulkomaat/2009121510785951_ul.shtml")
      assert_equal "200", reply.code
      assert reply.body =~ /Iltalehti/
    end
  end
end

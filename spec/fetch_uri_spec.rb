# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'
require 'fetch_uri.rb'

describe "Fetching URI with get" do
  it "fetch an iltalehti uri" do
	reply = fetch_uri("http://www.iltalehti.fi/ulkomaat/2009121510785951_ul.shtml")
	expect(reply.code).to eq("200")
	expect(reply.body =~ /Iltalehti/).to eq(283)
  end
end

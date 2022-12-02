require "./spec_helper"

describe Cgit::Auth do
  # TODO: Write tests

  it "works" do
    session = Cgit::Auth::Session.new("jokke")
    deserialized_session = Cgit::Auth::Session.deserialize(
      session.serialize
    )
    session.user.should eq("jokke")
    deserialized_session.user.should eq("jokke")
    session.expired?.should be_false
    deserialized_session.expired?.should be_false
  end
end

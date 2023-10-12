shared_examples "empty response body" do
  it "should not return json body" do
    expect(json_body).to_not be_present
  end
end
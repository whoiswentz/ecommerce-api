shared_examples "return error message" do |message|
  it "should return error message" do
    expect(json_body['errors']['message']).to eq message
  end
end
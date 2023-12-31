shared_examples "return error fields" do |keys|
  keys.each do |key|
    it "should return #{key} error" do
      expect(json_body['errors']['fields']).to have_key(key)
    end
  end
end
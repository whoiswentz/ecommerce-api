shared_examples "simple post request with invalid params" do |model|
  it "should not create a new #{model}" do
    expect do
      post url, headers: auth_header(user), params: params
    end.not_to change(model, :count)
  end

  it "should return error message" do
    post url, headers: auth_header(user), params: params
    expect(json_body['errors']['fields']).to have_key('name')
  end

  it "should return unprocessable entity status" do
    post url, headers: auth_header(user), params: params
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
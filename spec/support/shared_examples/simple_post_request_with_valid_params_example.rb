shared_examples "simple post request with valid params" do |model, json_field, json_only|
  it "should add a new #{model}" do
    expect do
      post url, headers: auth_header(user), params: params
    end.to change(model, :count).by(1)
  end

  it "should return last added #{model}" do
    post url, headers: auth_header(user), params: params

    expected_model = model.last.as_json(only: json_only)
    expect(json_body[json_field]).to eq expected_model
  end

  it "should return http status ok" do
    post url, headers: auth_header(user), params: params
    expect(response).to have_http_status(:ok)
  end
end
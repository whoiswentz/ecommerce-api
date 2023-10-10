shared_examples "created http status code" do
  it "returns created status" do
    expect(response).to have_http_status(:created)
  end
end
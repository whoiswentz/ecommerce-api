shared_examples "ok http status code" do
  it "returns ok status" do
    expect(response).to have_http_status(:ok)
  end
end
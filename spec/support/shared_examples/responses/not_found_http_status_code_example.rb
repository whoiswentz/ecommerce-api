shared_examples "not found http status code" do
  it "returns not found status" do
    expect(response).to have_http_status(:not_found)
  end
end
shared_examples "not content http status code" do
  it "should return http status no_content" do
    expect(response).to have_http_status(:no_content)
  end
end
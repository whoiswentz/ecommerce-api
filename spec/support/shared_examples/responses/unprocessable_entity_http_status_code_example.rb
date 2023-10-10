shared_examples "unprocessable entity http status code" do
  it "should return unprocessable entity http status code" do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
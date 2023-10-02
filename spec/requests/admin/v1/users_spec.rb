require 'rails_helper'

RSpec.describe Admin::V1::UsersController, type: :request do
  let(:user) { create(:user) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 5) }

    it "should return all Users" do
      get url, headers: auth_header(user)

      expect(json_body['users']).to contain_exactly *users.as_json(only: %i(id name email profile))
    end

    it "should return status code ok" do
      get url, headers: auth_header(user)

      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /users" do
    let(:url) { "/admin/v1/users" }

    context "with invalid params" do
      let(:params) { { user: attributes_for(:user, email: nil) }.to_json }

      it "should not add new User" do
        expect do
          post url, headers: auth_header(user), params: params
        end.to change(User, :count).by(1)
      end

      it "should return error message" do
        post url, headers: auth_header(user), params: params
        expect(json_body['errors']['fields']).to have_key('email')
      end

      it "should return unprocessable entity status" do
        post url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      let(:params) { { user: attributes_for(:user) }.to_json }

      it "should add a new User" do
        expect do
          post url, headers: auth_header(user), params: params
        end.to change(User, :count).by(2)
      end

      it "should return last added User" do
        post url, headers: auth_header(user), params: params

        expected = User.last.as_json(only: %i(id name email profile))
        expect(json_body['user']).to eq expected
      end

      it "should return http status ok" do
        post url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:created)
      end
    end
  end

  context "PATCH /user/:id" do
    let(:user2) { create(:user) }
    let(:url) { "/admin/v1/users/#{user2.id}" }

    context "with invalid params" do
      let(:params) { { user: attributes_for(:user, email: nil) }.to_json }

      it "should not update" do
        old_email = user2.email
        patch url, headers: auth_header(user), params: params
        user2.reload
        expect(user2.email).to eq old_email
      end

      it "should return error message" do
        patch url, headers: auth_header(user), params: params
        expect(json_body['errors']['fields']).to have_key('email')
      end

      it "should return unprocessable entity status" do
        patch url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      let(:email) { "email@email.com" }
      let(:params) { { user: attributes_for(:user, email: email) }.to_json }

      it "should update" do
        patch url, headers: auth_header(user), params: params
        user2.reload
        expect(user2.email).to eq email
      end

      it "should return updated json" do
        patch url, headers: auth_header(user), params: params
        user2.reload
        expect(json_body['user']).to eq user2.as_json(only: %w(id name email profile))
      end

      it "should return http status ok" do
        patch url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context "DELETE /users/:id" do
    let!(:user2) { create(:user) }
    let(:url) { "/admin/v1/users/#{user2.id}" }

    context "with valid id" do
      it "should delete" do
        expect {
          delete url, headers: auth_header(user)
        }.to change(User, :count).by(0)
      end

      it "should not return json body" do
        delete url, headers: auth_header(user)
        expect(json_body).to_not be_present
      end

      it "should return http status no_content" do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
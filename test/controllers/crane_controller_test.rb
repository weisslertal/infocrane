require 'test_helper'

class CraneControllerTest < ActionDispatch::IntegrationTest
  describe "#show" do
    let(:rest) { FactoryBot.create(:italian_with_tenbis) }
    it "retrieve restaurant successfully" do
      get :show, params: { id: rest.id }
      expect(response.status).to eq 200
    end

    it "retrieve the correct restaurant" do
      get :show, params: { id: rest.id }
      body = JSON.parse(response.body)
      expect(body["name"]).to be_present
      expect(body["cuisine"]).to eql("italian")
      expect(body["tenbis"]).to be true
    end

    it "retrieve non existing restaurant" do
      get :show, params: { id: 12345 }
      expect(response.status).to eq 404
    end
  end
end

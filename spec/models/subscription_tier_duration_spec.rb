# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subscription, type: :model do
  describe "tier-specific duration" do
    let(:product) { create(:membership_product, duration_in_months: 12) }
    let(:tier_category) { product.tier_category }
    let(:tier) { tier_category.variants.first }
    let(:purchase) { create(:membership_purchase, link: product, variant_attributes: [tier]) }
    let(:subscription) { purchase.subscription }

    it "uses tier duration when available" do
      tier.update!(duration_in_months: 24)
      expect(subscription.tier_duration_in_months).to eq(24)
    end

    it "returns nil when tier has no duration" do
      tier.update!(duration_in_months: nil)
      expect(subscription.tier_duration_in_months).to be_nil
    end

    it "returns nil when no tier is present" do
      purchase.update!(variant_attributes: [])
      expect(subscription.tier_duration_in_months).to be_nil
    end
  end
end

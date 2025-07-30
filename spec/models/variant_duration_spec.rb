# frozen_string_literal: true

require "rails_helper"

RSpec.describe Variant, type: :model do
  describe "tier-specific duration" do
    let(:product) { create(:membership_product, duration_in_months: 12) }
    let(:tier_category) { product.tier_category }
    let(:tier) { tier_category.variants.first }

    it "uses tier duration when set" do
      tier.update!(duration_in_months: 24)
      expect(tier.tier_duration_in_months).to eq(24)
    end

    it "falls back to product duration when tier duration is nil" do
      tier.update!(duration_in_months: nil)
      expect(tier.tier_duration_in_months).to eq(12)
    end

    it "returns nil when both tier and product duration are nil" do
      product.update!(duration_in_months: nil)
      tier.update!(duration_in_months: nil)
      expect(tier.tier_duration_in_months).to be_nil
    end

    it "displays duration correctly" do
      tier.update!(duration_in_months: 6)
      expect(tier.tier_duration_display).to eq("6 months")
    end

    it "displays singular month correctly" do
      tier.update!(duration_in_months: 1)
      expect(tier.tier_duration_display).to eq("1 month")
    end

    it "returns nil for display when duration is nil" do
      tier.update!(duration_in_months: nil)
      expect(tier.tier_duration_display).to be_nil
    end
  end
end

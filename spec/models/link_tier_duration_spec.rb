# frozen_string_literal: true

require "rails_helper"

RSpec.describe Link, type: :model do
  describe "tier-specific duration" do
    let(:product) { create(:membership_product, duration_in_months: 12) }
    let(:tier_category) { product.tier_category }
    let(:tier) { tier_category.variants.first }

    it "detects custom tier duration" do
      tier.update!(duration_in_months: 24)
      expect(product.tier_has_custom_duration?(tier)).to be true
    end

    it "does not detect custom duration when tier uses product duration" do
      tier.update!(duration_in_months: nil)
      expect(product.tier_has_custom_duration?(tier)).to be false
    end

    it "does not detect custom duration when tier duration equals product duration" do
      tier.update!(duration_in_months: 12)
      expect(product.tier_has_custom_duration?(tier)).to be false
    end

    it "displays tier duration correctly" do
      tier.update!(duration_in_months: 6)
      expect(product.tier_duration_display(tier)).to eq("6 months")
    end

    it "displays singular month correctly" do
      tier.update!(duration_in_months: 1)
      expect(product.tier_duration_display(tier)).to eq("1 month")
    end

    it "returns nil for display when duration is nil" do
      tier.update!(duration_in_months: nil)
      expect(product.tier_duration_display(tier)).to be_nil
    end
  end
end

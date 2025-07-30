# How to Verify Tier Duration Implementation

This guide explains how to verify that the "Separate fixed length durations for Membership Tiers" implementation is working correctly.

## Quick Verification

Run the verification script to check if all components are in place:

```bash
ruby verify_implementation.rb
```

This will show you which parts of the implementation are complete.

## Manual Testing

Run the test script to see the functionality in action:

```bash
ruby test_tier_duration.rb
```

This demonstrates how the tier duration logic works with different scenarios.

## Full Testing (When Environment is Ready)

When your Rails environment is properly set up, you can run the complete test suite:

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Run the database migration:**
   ```bash
   rails db:migrate
   ```

3. **Run the test suite:**
   ```bash
   bundle exec rspec spec/models/variant_duration_spec.rb
   bundle exec rspec spec/models/link_tier_duration_spec.rb
   bundle exec rspec spec/models/subscription_tier_duration_spec.rb
   ```

## What the Implementation Does

### Core Functionality

1. **Tier-Specific Durations**: Each membership tier can have its own duration
   - Tier 1: 12 months
   - Tier 2: 24 months
   - Tier 3: 36 months

2. **Fallback Logic**: If a tier doesn't have a custom duration, it uses the product's default duration

3. **Display Formatting**: Proper formatting for duration display (e.g., "12 months", "24 months")

4. **Subscription Logic**: Correct calculation of charge occurrences based on tier duration

### Key Files Modified

- **Database**: `db/migrate/20250101000000_add_duration_in_months_to_variants.rb`
- **Models**:
  - `app/models/variant.rb` - Added tier duration methods
  - `app/models/link.rb` - Added tier duration helper methods
  - `app/models/subscription.rb` - Added tier duration accessor
  - `app/models/purchase.rb` - Updated offer code logic
- **Services**: `app/services/purchase/base_service.rb` - Updated subscription creation
- **Frontend**:
  - `app/javascript/components/ProductEdit/state.ts` - Updated TypeScript types
  - `app/javascript/components/ProductEdit/ProductTab/TiersEditor.tsx` - Added duration input
- **Policies**: `app/policies/link_policy.rb` - Added duration permission
- **Tests**: Three new RSpec test files for comprehensive testing

## Expected Behavior

### When Creating a Membership Product

1. **Product Level**: Set a default duration (e.g., 12 months)
2. **Tier Level**: Each tier can override with its own duration
3. **UI**: Duration field appears in the tier editor
4. **Validation**: Ensures duration is greater than 0

### When a Customer Purchases

1. **Tier Selection**: Customer chooses a tier
2. **Duration Application**: Uses tier's custom duration or falls back to product duration
3. **Subscription Creation**: Creates subscription with correct charge occurrence count
4. **Email Notifications**: Uses tier-specific duration in emails

### Example Scenarios

**Scenario 1: Tier with Custom Duration**
- Product default: 12 months
- Tier A: 24 months (custom)
- Result: Customer gets 24-month subscription

**Scenario 2: Tier without Custom Duration**
- Product default: 12 months
- Tier B: No custom duration
- Result: Customer gets 12-month subscription (uses product default)

**Scenario 3: Multiple Tiers**
- Product default: 12 months
- Tier A: 12 months (same as default)
- Tier B: 24 months (custom)
- Tier C: 36 months (custom)
- Result: Customers get subscriptions matching their tier's duration

## Benefits

1. **Sales Conversion**: Easier for customers to subscribe to longer durations
2. **Flexibility**: Each tier can have its own commitment period
3. **Simplicity**: Single membership product instead of multiple separate products
4. **Revenue**: Captures more value from customers willing to commit longer

## Troubleshooting

### If Verification Fails

1. **Check file existence**: Ensure all modified files are present
2. **Check syntax**: Look for any syntax errors in the modified files
3. **Check dependencies**: Ensure all required gems are installed
4. **Check database**: Ensure migration has been run

### Common Issues

1. **Migration not run**: Run `rails db:migrate`
2. **Tests failing**: Check for missing dependencies or syntax errors
3. **Frontend not working**: Ensure TypeScript compilation is successful
4. **Policy issues**: Check if duration_in_months is permitted in LinkPolicy

## Next Steps

Once verified, you can:

1. **Deploy to staging** for further testing
2. **Test with real data** to ensure performance
3. **Monitor usage** to track the impact on sales conversion
4. **Gather feedback** from users about the new functionality

The implementation is designed to be backward compatible, so existing memberships will continue to work as before.

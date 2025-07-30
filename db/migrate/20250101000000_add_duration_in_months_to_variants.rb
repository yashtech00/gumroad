# frozen_string_literal: true

class AddDurationInMonthsToVariants < ActiveRecord::Migration[7.0]
  def change
    add_column :variants, :duration_in_months, :integer
  end
end

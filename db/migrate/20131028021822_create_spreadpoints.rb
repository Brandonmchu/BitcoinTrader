class CreateSpreadpoints < ActiveRecord::Migration
  def change
    create_table :spreadpoints do |t|
      t.float :virtexBidPrice
      t.float :virtexBidQty
      t.float :virtexAskPrice
      t.float :virtexAskQty
      t.float :stampBidPrice
      t.float :stampBidQty
      t.float :stampAskPrice
      t.float :stampAskQty
      t.float :lowSpread
      t.float :maxSpread

      t.timestamps
    end
  end
end

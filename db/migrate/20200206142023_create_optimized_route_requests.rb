# frozen_string_literal: true

class CreateOptimizedRouteRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :optimized_route_requests, id: :uuid do |t|
      t.text :request, null: false
      t.string :hashed_request, null: false
      t.index :hashed_request, unique: true
      t.text :response
      t.uuid :provider_id, null: false
      t.timestamp :created_at
    end
  end
end

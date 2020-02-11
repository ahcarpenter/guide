# frozen_string_literal: true

class EnableUuid < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.execute('CREATE extension pgcrypto')
  end
end

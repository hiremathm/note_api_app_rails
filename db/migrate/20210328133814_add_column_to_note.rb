class AddColumnToNote < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :lock_version, :integer
  end
end

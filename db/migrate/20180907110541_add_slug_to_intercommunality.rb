class AddSlugToIntercommunality < ActiveRecord::Migration[5.0]
  def change
    add_column :intercommunalities, :slug, :string
  end
end

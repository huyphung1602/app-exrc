class AddIntercommunalityAssociationToCommunes < ActiveRecord::Migration[5.0]
  def change
    add_column :communes, :intercommunality_id, :integer
  end
end

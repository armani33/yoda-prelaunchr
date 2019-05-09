ActiveAdmin.register Order do
  csv do
    column :id
    column :email
    column :state
    column :referrer_id
    column :amount_cents
    column :created_at
    column :updated_at
  end

  actions :index, :show
end

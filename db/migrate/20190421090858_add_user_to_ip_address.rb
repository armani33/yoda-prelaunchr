class AddUserToIpAddress < ActiveRecord::Migration[5.2]
  def change
    add_reference :ip_addresses, :user, index: true
  end
end

class Share < ApplicationRecord
  belongs_to :post

  validates :post_id, :network_user_name, :network_user_id, presence: true
  validates :network_share_id, presence: true, uniqueness: { scope: :post_id }

  def self.to_csv
    attributes = [:network_user_name, :network_share_id]

    CSV.generate(headers: true) do |csv|
      csv << ['User Name', 'Share ID']

      all.each do |share|
        csv << attributes.map{ |attr| share.send(attr) }
      end
    end
  end

  def posted_at
    nil
  end
end

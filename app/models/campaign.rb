class Campaign < ApplicationRecord
  extend FriendlyId
  belongs_to :organization
  has_many :posts, dependent: :destroy
  friendly_id :name, use: :scoped, scope: :organization

  validates :organization_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :organization_id }

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def engagement_count
    posts.map(&:engagement_count).sum
  end

  def flagged_interactions
    posts.map(&:flagged_interactions).flatten
  end

  def flagged_interactions_to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Interaction Type', 'User Name', 'Content', 'Posted']

      flagged_interactions.each do |flagged_interaction|
        case flagged_interaction
          when Comment
            content = "#{flagged_interaction.message} --- #{flagged_interaction.attachment_url}"
          when Reaction
            content = flagged_interaction.category
          else
            content = nil
        end

        csv << [flagged_interaction.class.name, flagged_interaction.network_user_name, content, (flagged_interaction.posted_at || 'Not Available')]
      end
    end
  end

  def networks
    posts.map(&:network).map(&:slug).uniq.sort
  end
end

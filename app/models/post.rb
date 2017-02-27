class Post < ApplicationRecord
  belongs_to :campaign
  belongs_to :network
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :tweets, dependent: :destroy

  # Make network_parent_id conditional on facebook when more networks added
  validates :campaign_id, :network_id, :network_parent_id, presence: true
  validates :network_post_id, presence: true, uniqueness: { scope: [:campaign_id, :network_id] }

  def engagement_count
    case network
      when Network.facebook
        comments.count + reactions.count
      when Network.twitter
        0
      when Network.instagram
        0
      else
        0
    end
  end

  def engagement_types
    case network
      when Network.facebook
        'Comments & Reactions'
      when Network.twitter
        0
      when Network.instagram
        0
      else
        0
    end
  end

  def flagged_interactions
    case network
      when Network.facebook
        comments.flagged.sort + reactions.flagged.sort
      else
        []
    end
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

  def can_be_synced?
    self.synced_at.nil? || Time.now.utc > self.synced_at + 15.minutes
  end

  def sync(user, token)
    job = SyncPostJob.perform_later(user, self, token)
    update_attribute(:job_id, job.job_id)
  end

  def update_sync_status
    update_attributes!(
      synced_at: DateTime.now.utc,
      sync_count: self.sync_count + 1
    )
  end
end

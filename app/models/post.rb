class Post < ApplicationRecord
  belongs_to :campaign
  belongs_to :network
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy

  # Make network_parent_id conditional on facebook when more networks added
  validates :campaign_id, :network_id, presence: true
  validates :network_post_id, presence: true, uniqueness: { scope: [:campaign_id, :network_id] }
  validates_presence_of :network_parent_id

  def can_be_synced?
    self.synced_at.nil? || Time.now.utc > self.synced_at + 15.minutes
  end

  def engagement_count
    comments.count + reactions.count
  end

  def engagement_types
    'Comments & Reactions'
  end

  def flagged_interactions
    comments.flagged.sort + reactions.flagged.sort
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

  def sync(user=nil)
    job = SyncPostJob.perform_later(self, user)
    update_attribute(:job_id, job.job_id)
  end

  def update_sync_status
    update_attributes!(
      synced_at: DateTime.now.utc,
      sync_count: self.sync_count + 1
    )
  end
end

class Post < ApplicationRecord
  belongs_to :campaign
  belongs_to :network
  belongs_to :twitter_token
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :tweets, dependent: :destroy

  # Make network_parent_id conditional on facebook when more networks added
  validates :campaign_id, :network_id, presence: true
  validates :network_post_id, presence: true, uniqueness: { scope: [:campaign_id, :network_id] }
  validates_presence_of :network_parent_id, if: :for_facebook?
  validates_presence_of :twitter_token_id, if: :for_twitter?
  validate :twitter_token_validation, if: :for_twitter?

  def can_be_synced?
    self.synced_at.nil? || Time.now.utc > self.synced_at + 15.minutes
  end

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

  def for_facebook?
    network == Network.facebook
  end

  def for_twitter?
    network == Network.twitter
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

  private

  def twitter_token_validation
    errors.add(:twitter_account, "does not exist for this organization.") unless campaign.organization.twitter_tokens.include?(twitter_token)
  end
end

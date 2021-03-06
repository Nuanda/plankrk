class Discussion < ActiveRecord::Base
  belongs_to :author,
             class_name: 'User',
             foreign_key: 'author_id',
             required: true

  has_many :comments, dependent: :destroy

  validates_presence_of :fid

  before_destroy :check_comments, prepend: true


  scope :newest_first, -> { order(created_at: :desc) }

  scope :about, ->(fid) { where(fid: fid).newest_first }

  scope :recently_created, -> { newest_first.limit(5) }

  scope :recently_commented, -> {
    select('discussions.*', 'MAX(comments.created_at)').
    joins(:comments).
    group('discussions.id').
    order('MAX(comments.created_at) DESC').
    limit(5)

    # # The original SQL version
    # find_by_sql(
    #   'SELECT discussions.*, MAX(comments.created_at) AS sort
    #    FROM discussions
    #    INNER JOIN comments ON comments.discussion_id = discussions.id
    #    GROUP BY discussions.id
    #    ORDER BY SORT DESC
    #    LIMIT 5')
  }

  # Please note it does NOT include the discussion author unless that user
  # is also an author of at least a single comment in this discussion
  def commenters
    # User.joins(:comments).where(comments: {discussion_id: id}).uniq
    User.where(id: comments.pluck(:author_id))
  end


  private

  def check_comments
    commenters.count < 2
  end

end

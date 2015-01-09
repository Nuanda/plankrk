class Discussion < ActiveRecord::Base
  belongs_to :author,
             class_name: 'User',
             foreign_key: 'author_id',
             required: true

  has_many :comments

  validates_presence_of :fid

  scope :about_fid, ->(fid) { where(fid: fid).order(:created_at) }

  scope :recently_created, -> { order(created_at: :desc).limit(5) }

  scope :recently_commented, -> {
    # select('discussions.id', 'MAX(comments.created_at)').
    # joins(:comments).
    # group('discussions.id').
    # order('MAX(comments.created_at) DESC').
    # limit(5)

    find_by_sql(
      'SELECT discussions.*, MAX(comments.created_at) AS sort
       FROM discussions
       INNER JOIN comments ON comments.discussion_id = discussions.id
       GROUP BY discussions.id
       ORDER BY SORT DESC
       LIMIT 5')
  }

end

class Discussion < ActiveRecord::Base
  belongs_to :author,
             class_name: 'User',
             foreign_key: 'author_id'

  validates_presence_of :fid

  scope :about_fid, ->(fid) { where(fid: fid).order(:created_at) }

  scope :recently_created, -> { order(created_at: :desc).limit(5) }

  # TODO FIXME add :recently_commented scope to return 5 discussion
  # with the most recent comments
  # scope :recently_commented, -> { order(created_at: :desc).limit(5) }

end

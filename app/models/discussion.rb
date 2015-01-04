class Discussion < ActiveRecord::Base

  validates_presence_of :fid

  scope :about_fid, ->(fid) { where(fid: fid).order(:created_at) }

  scope :recently_created, -> { order(created_at: :desc).limit(5) }

  # TODO FIXME change to proper query when comments model is available
  # TODO FIXME add specs for this scope when implemented
  scope :recently_commented, -> { order(created_at: :desc).limit(5) }

end

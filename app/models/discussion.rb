class Discussion < ActiveRecord::Base

  validates_presence_of :fid

  scope :about_fid, ->(fid) { where(fid: fid).order(:created_at) }

end

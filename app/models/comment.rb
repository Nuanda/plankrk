class Comment < ActiveRecord::Base

  belongs_to :author,
             class_name: 'User',
             foreign_key: 'author_id',
             required: true

  belongs_to :discussion,
             required: true

  # Thread is our name for a set of comments replying to another comment
  belongs_to :thread, class_name: 'Comment'

  has_many :replies,
           class_name: 'Comment',
           foreign_key: 'thread_id'

end

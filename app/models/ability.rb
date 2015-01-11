class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Discussion, author_id: user.id

      can :destroy, Discussion do |discussion|
        discussion.author_id == user.id &&
          discussion.comments.by(user) == discussion.comments
      end
    end
  end
end

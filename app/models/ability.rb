class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:create, :destroy], Discussion, author_id: user.id
    end
  end
end

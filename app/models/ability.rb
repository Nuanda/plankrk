class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :create, Discussion, author_id: user.id
    end
  end
end

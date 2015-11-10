class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is?(:admin)
      can :manage, :all
    elsif user.is?(:user)
      # user can create songs
      can :create, Song

      can :update, Song do |song|
        song.try(:user) == user
      end
      can :destroy, Song do |song|
        song.try(:user) == user
      end
    else
      can :show, :all
    end
  end
end

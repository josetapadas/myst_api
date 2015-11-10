class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is?(:admin)
      can :manage, :all
    elsif user.is?(:user)
      can :create, Song

      can [:destroy, :update], Song do |song|
        song.try(:user) == user
      end

      can :create, SongTrack

      can [:destroy, :update], SongTrack do |song_track|
        song_track.try(:user) == user
      end
    else
      can [:index, :show], :all
    end
  end
end

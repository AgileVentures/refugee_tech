class Ability
  include CanCan::Ability

  def initialize(user)

      user ||= User.new # guest user (not logged in)

      if user_signed_in?
        can :manage, User
        can :manage, Ability
        can :manage, Language
      end
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end

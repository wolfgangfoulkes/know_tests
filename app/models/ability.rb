class Ability
  include CanCan::Ability


  def initialize(user)
    can :read, :all
    can :create, Event
    can [:update, :destroy], Event, :user_id => user.id

    # all owned events for user
    owner_events = user.events.pluck(:id)

    # override :read, :all
    cannot [:read], Comment, { role: ["default"] }

    # any user can create a default comment
    can [:create], Comment,
    {   
        user_id: user.id,
        role: ["default"]
    }

    # event owner can create, read, destroy all comments
    can [:create, :read, :destroy], Comment,
    {   
        root_id: owner_events,
        role: ["owner", "public", "default", "reply"]
    }

    # comment owner can read and destroy their own comments
    can [:read, :destroy], Comment,
    {   
        user_id: user.id,
        role: ["public", "default"]
    }

    # set roles only for top-level comments
    can [:set_role], Comment,
    {
        commentable_id: owner_events,
        role: ["public", "default"]
    }

    # users can reply
    can [:create, :read, :destroy], Comment do |comment|
        (comment.role == "reply") && (comment.commentable.user_id == user.id)
    end

    can [:read], Comment do |comment|
        (comment.role == "reply") && (comment.commentable.role == "public")
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :admin
      can :manage, :all
    else
      if user.role? :technician
        can :read, [Inspection, Checkpoint, Task, Closing]
        can :manage, [Task]
      end
      if user.role? :engineer
        can :read, [Aircraft, Konfiguration, Zone, Item]
        can [:create, :read, :update], [Part]
        can [:create, :read, :update], [Protocol, Checkpoint]
        can [:create, :read, :update], [Inspection]
        can :manage, [Task, Closing]
      end
    end
  end

end

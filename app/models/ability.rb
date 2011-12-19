class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :admin
      can :manage, :all
    else
      if user.role? :technician
        can :read, [Inspection, Protocol, Checkpoint, Task, Closing]
        can :manage, [Task] do |task|
          task.try(:technician) == user
        end
      end
      if user.role? :engineer
        can :read, [Aircraft, Konfiguration, Zone, Item]
        can [:create, :read, :update], Part
        can [:create, :read, :update], Inspection
        can [:create, :read, :update], [Protocol, Checkpoint]
        can :manage, [Task, Closing]
      end
    end
  end

end

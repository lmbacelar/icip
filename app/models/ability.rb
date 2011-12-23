class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :admin
      can :manage, :all
    else
      if user.role? :technician
        can [:read, :update], User do |u|
          u == user
        end
        can :read, [Protocol, Checkpoint, Tasc, Closing]
        can [:read, :update], Inspection do |insp|
          insp.technician_id == user.id && insp.execution_date.nil?
        end
        can :manage, [Tasc]
      end
      if user.role? :engineer
        can :read, [Aircraft, Konfiguration, Zone, Item]
        can [:create, :read, :update], Part
        can [:create, :read, :update], Inspection
        can [:create, :read, :update], [Protocol, Checkpoint]
        can :manage, [Tasc, Closing]
      end
    end
  end

end

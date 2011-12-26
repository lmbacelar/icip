class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role? :admin
      can :manage, :all
    else
      if user.role? :technician
        # Can read and update own user
        # TODO:
        # Restrict update fields (cannot update roles through nested attributes, unless authorized)
        can [:read, :update], User do |u|
          u == user
        end
        # Can read Protocol, CheckPoint
        can :read, [Protocol, Checkpoint]
        # Can read inspections assigned to user
        can :read, Inspection do |ins|
          ins.technician_id == user.id
        end
        # Can update Inspections assigned to user AND
        # while inspection is not executed OR
        # is executed but has no tasks OR
        # is executed and has tasks but all remain open
        can :update, Inspection do |ins|
          ins = Inspection.find(ins.id)
          ins.technician_id == user.id && (!ins.executed || ins.tascs.empty? || ins.tascs.closed.empty?)
        end
        # Can manage Tasks
        # TODO:
        # Restrict further
        #   Can manage Tasks for inspections assigned to user while tasks remain open
        can :manage, [Tasc]

        # Can read Closings for Tasks created by himself
        can :read, [Closing] do |c|
          c.task.technician_id == user.id
        end
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

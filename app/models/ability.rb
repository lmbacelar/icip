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
          ins.id && Inspection.find(ins.id).technician_ids.include?(user.id)
        end
        # Can update Inspections assigned to user AND
        # while inspection is not executed OR
        # is executed but has no tasks OR
        # is executed and has tasks but all remain open
        can :update, Inspection do |ins|
          ins = Inspection.find(ins.id)
          ins.technician_ids.include?(user.id) && (!ins.executed || ins.tascs.empty? || ins.tascs.closed.empty?)
        end
        # Can create Tasks
        # TODO: Restrict further: only on inspections assigned to user
        can :create, Tasc
        # Can read Tasks assigned to him
        can :read, Tasc do |tas|
          tas.inspection.technician_ids.include?(user.id)
        end
        # Can update and destroy Tasks assigned to him, while the inspection is not closed
        can [:update, :destroy], Tasc do |tas|
          tas.inspection.technician_ids.include?(user.id) && !tas.inspection.executed
        end

        # Can read Closings for Tasks created by himself
        can :read, [Closing] do |c|
          c.tasc.technician_id == user.id
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

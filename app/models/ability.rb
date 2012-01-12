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
        can [:create, :read, :update], [Protocol, Checkpoint]
        # Can create and read all Inspections
        can [:create, :read], Inspection
        # Can update Inspections as long as they are not closed
        can :update, Inspection do |ins|
          ins.state.to_sym != :closed
        end
        # Can destroy Inspections wich have not yet been executed
        can :destroy, Inspection do |ins|
          ins.state == :unassigned || ins.state == :assigned
        end
        # Can create and read all Tasks, Closings
        # TODO: Restrict further creation:
        #   Only create Tasks on open Inspection (if any).
        #   Only create closing on open Tascs.
        can [:create, :read], [Tasc, Closing]
        # Can update, destroy open Tasks
        can [:update, :destroy], Tasc do |tas|
          tas.open?
        end
        # Can update, destroy Closings if Tasks are closed
        can [:update, :destroy], Closing do |c|
          c.tasc.closed?
        end
      end
    end
  end

end

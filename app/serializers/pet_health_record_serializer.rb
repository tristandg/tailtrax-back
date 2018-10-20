class PetHealthRecordSerializer < ActiveModel::Serializer
  attributes :id, :condition_notes, :severity_override, :vet, :user_id, :pet, :medication, :vaccine, :diagnosis, :reminders, :check_in_date

  def vet
    if object.vet_id
      @user = User.includes(:businesses).find(object.vet_id)
      @business = nil

      @user.businesses.each do |bus|
        if bus.business_type == 'vet'
          @business = bus
          break
        end
      end

      @business
    end
  end
end
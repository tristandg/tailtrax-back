class PetSerializer < ActiveModel::Serializer
  attributes :id, :name, :gender, :weight, :pet_description, :pet_health_records, :medications, :vaccines, :diagnoses,
             :pet_profile_pic, :background_image, :location, :microchip, :akc_reg_number, :akc_reg_date, :birthday, :owner, :food, :supplemental, :health_issue, :breed, :marking, :color, :vets

  def owner
    @user = User.find_by(id: object.user_id)

    if @user != nil
      UserSerializer.new(@user)
    end
  end

  def vets
    object.businesses
  end

  def breed
    if object.pet_breed
      object.pet_breed.name
    else
      ""
    end
  end

  def vaccines
    if object.vaccines != nil
      object.vaccines.uniq
    end
  end

  def diagnoses
    if object.diagnoses != nil
      object.diagnoses.uniq
    end
  end

  def medications
    if object.medications != nil
      object.diagnoses.uniq
    end
  end

  def color
    if object.pet_color
      object.pet_color.name
    else
      ""
    end
  end

  def marking
    if object.pet_marking
      object.pet_marking.name
    else
      ""
    end
  end

end
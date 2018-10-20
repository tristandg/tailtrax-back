class PetSkeletonInfoSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :gender, :weight, :pet_description, :pet_profile_pic, :pet_breed_id, :color_id,
                    :marking_id, :location, :microchip, :akc_reg_number, :akc_reg_date, :birthday, :litter_id, :background_image


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
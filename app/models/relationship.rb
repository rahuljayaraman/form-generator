class Relationship
  def initialize form=nil, source=nil
    @form = form
    @source = source || @form.source
  end

  def get_model
    @model ||= @source.initialize_dynamic_model
  end
  
  def has_manies
    @has_manies ||= @source.has_manies
  end

  def belongs_tos
    @belongs_tos ||= @source.belongs_tos
  end

  def habtms
    @habtms ||= @source.habtms
  end

  def belongs_to_models
    @belongs_to_models ||= belongs_tos.map(&:initialize_dynamic_model)
  end

  def habtm_models
    @habtm_models ||= habtms.map(&:initialize_dynamic_model)
  end

  def has_many_models
    @has_many_models ||= has_manies.map(&:initialize_dynamic_model)
  end

  def associated_models
    (has_many_models + belongs_to_models + habtm_models) << get_model
  end

  def direct_attributes
    @direct ||= @source.source_attributes
  end

  def belongs_to_attributes
    @belongs_to_attributes ||= belongs_tos.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def has_many_attributes
    @has_many_attributes ||= has_manies.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def habtm_attributes
    @habtm_attributes ||= habtms.map(&:source_attributes).inject([]){|initial,sum| initial + sum}
  end

  def define!
    User.define_relationships associated_models
  end
end

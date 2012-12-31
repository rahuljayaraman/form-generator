module Mapping
  def mapping
    { 
      'Word' => String,
      'Number' => Integer,
      'Paragraph' => String,
      'Date & Time' => DateTime,
      'Date' => Date,
      'Time' => Time,
      'Collection' => Array,
      'Radio Buttons' => Array,
      'Check Boxes' => Array,
      'Password' => String,
      'Email' => String,
      'Telephone' => String,
      'True or False' => Boolean
    }
  end

  def view_mapping
    { 
      'Word' => 'string',
      'Number' => 'integer',
      'Paragraph' => 'text',
      'Date & Time' => 'datetime',
      'Date' => 'date',
      'Time' => 'time',
      'Collection' => 'select',
      'Radio Buttons' => 'radio_buttons',
      'Check Boxes' => 'check_boxes',
      'Password' => 'password',
      'Email' => 'email',
      'Telephone' => 'tel',
      'True or False' => 'boolean'
    }
  end
end

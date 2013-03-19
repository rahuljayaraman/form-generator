module Mapping
  def mapping
    { 
      'Word' => String,
      'Number' => Integer,
      'Paragraph' => String,
      'Date & Time' => DateTime,
      'Date' => Date,
      'Time' => Time,
      'Yes or No' => Boolean,
      'Password' => String,
      'True or False' => Boolean,
      'File' => String,
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
      'Yes or No' => 'radio_buttons',
      'Password' => 'password',
      'True or False' => 'boolean',
      'File' => 'file',
    }
  end
end

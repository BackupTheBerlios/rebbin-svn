require 'cgi'
require 'colouriser'

module PasteHelper
  def PasteHelper.get_supported_languages
    Colouriser.languages.keys.sort
  end

  def PasteHelper.get_languages_map
    Colouriser.languages
  end
  
  def PasteHelper.prev_id(id)
    first_id = Paste.find(:all, :order => "id")[0].id
    if id > first_id
      id - 1
    else
      id
    end
  end

  def PasteHelper.next_id(id)
    last_id = Paste.find(:all, :order => "id")[-1].id
    if id == last_id
      last_id
    else
      id + 1
    end
  end
end

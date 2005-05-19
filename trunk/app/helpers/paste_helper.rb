require 'cgi'
require 'colouriser'

module PasteHelper
  $languages = {
    "Assembly" => "asm",
    "Bash" => "sh",
    "C" => "c",
    "C++" => "c",
    "C#" => "cs",
    "CSS" => "css",
    "Cobol" => "cob",
    "DOS-Batch" => "bat",
    "Haskell" => "haskell",
    "HTML" => "xml",
    "Java" => "java",
    "Javascript" => "js",
    "Latex" => "tex",
    "Lisp" => "lisp",
    "Make" => "make",
    "Objective C" => "objc",
    "PHP" => "php",
    "Pascal" => "pas",
    "Perl" => "pl",
    "Plain Text" => "txt",
    "Prolog" => "pro",
    "Python" => "py",
    "Ruby" => "rb",
    "SQL" => "sql",
    "Tcl/Tk" => "tcl",
    "Visual Basic" => "vb",
    "XML" => "xml",
  }

  def PasteHelper.get_languages
    $languages.keys.sort
  end
  
  def PasteHelper.prev_id(id)
    first_id = Paste.find(:all, :order => "id")[0].id
    if id > first_id
      return id - 1
    else
      return id
    end
  end

  def PasteHelper.next_id(id)
    last_id = Paste.find(:all, :order => "id")[-1].id
    if id == last_id
      return last_id
    else
      return id + 1
    end
  end
end

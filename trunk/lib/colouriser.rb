# colouriser.rb: colourise text, based upon highlight tool
# author: Lawrence Oluyede <l.oluyede@gmail.com>

require 'session'

# customize PATH to make it work under another platform
PATH = "/usr/bin/highlight"
ARGS = "-f -l -m 1 -t 8 -S %s"

module Colouriser
  @lang_map = {
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

  def Colouriser.languages
    @lang_map
  end

  def Colouriser.add_line_numbers(text)
    new_text = ""
    
    text.split("\n").each_with_index do |line, index|
      new_line = "%4d %s" % [index + 1, line]
      new_text = "%s%s\n" % [new_text, new_line]
    end
  
    new_text
  end

  def Colouriser.wordwrap(str, len = 80)
    str.gsub(/\n/, "\n\n").gsub(/(.{1,#{len}})(\s+|$)/, "\\1\n")
  end
  
  def Colouriser.colourise(text, lang)
    text.map do |x|
      x.chomp
    end.join("\n")
    
    if lang == "txt"
      text = wordwrap(text)      
      add_line_numbers(text)
    else
      session = Session.new
      
      params = ARGS % lang
      cmd = "%s %s" % [PATH, params]
      
      session.execute cmd, :stdin => text
    end
  end
end


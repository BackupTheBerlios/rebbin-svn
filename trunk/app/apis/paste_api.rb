module PasteApiStructs
  class Paste < ActionWebService::Struct
    member :author, :string
    member :language, :string
    member :description, :string
    member :body, :string
    member :created_on, :time
  end
end

class PasteApi < ActionWebService::API::Base
  inflect_names false

  api_method :num_of_pastes, :returns => [:int]
  api_method :get_languages, :returns => [[:string]]
  api_method :add_paste, :expects => [:string, :string, :string, :string],
    :returns => [:int]
  api_method :get_paste, :expects => [:int], :returns => [PasteApiStructs::Paste]
  api_method :get_latest_pastes, :returns => [[PasteApiStructs::Paste]]
end

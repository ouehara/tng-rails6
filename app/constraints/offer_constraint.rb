class OfferConstraint
  def self.matches?(request)
    FileTest.exists?("app/views/offer/#{request.params[:id]}.html.erb")
  end
end
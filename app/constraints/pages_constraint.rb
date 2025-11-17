class PagesConstraint
  def self.matches?(request)
    FileTest.exists?("app/views/pages/#{request.params[:id]}.html.erb")
  end
end
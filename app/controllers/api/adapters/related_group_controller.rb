class Api::Adapters::RelatedGroupController < ApplicationController
  def get_list
    res = ArticleGroup.get_sorted
    render json: res
  end
  
  def get_articles
    #groups = ArticleGroup.where(id: params[:id].split(/,/))
    #group_ids = []
    #groups.each do |group|
    #  group_ids << group.id
    #  group_ids << group.descendant_ids
    #end
    prm = params[:id].split(/,/)
    test = Article.in_groupings(prm)
    render json: test.to_json(:methods => [:medium_url])
  end
end
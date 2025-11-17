class Admin::PromoArticlesController < Admin::ApplicationController
  def index
    @lang = I18n.locale
    if params.has_key?(:set_locale)
      @lang = params[:set_locale]
    end 
    promoArt = PromoArticle.includes(:article).where(lang: I18n.locale).order(:position)
    @newestArticle = []
    promoArt.each do |promo|
      if(@newestArticle.length <= 4)
        @newestArticle += Article.where(id: promo.articles_id).translation_published(I18n.locale)
      end
    end
  end

  def update
    PromoArticle.
    update_or_create_by(
      {lang: I18n.locale.to_s, position: update_param[:position]},
      update_param
    )
  end

  # DELETE /admin/contacts/1
  # DELETE /admin/contacts/1.json
  def destroy
    @promo = PromoArticle.find(params[:id])
    lang = @promo.lang
    @promo.destroy
    respond_to do |format|
      format.html { redirect_to admin_promo_articles_path(set_locale:lang) }
    end
  end
  
  private
  def update_param
    params.permit(:articles_id,:position)
  end
end
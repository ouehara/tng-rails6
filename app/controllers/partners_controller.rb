class PartnersController < ApplicationController
    def index
        @partners = Partner.all.order(:position)
        respond_to do |format|
            format.html
            format.js
        end
    end
  end 
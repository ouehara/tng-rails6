class ServiceWorkerController < ApplicationController
    protect_from_forgery except: :service_worker
  
    def service_worker
      render "service_worker.js"
    end
  
    def manifest
      render "manifest.json"
    end
    def offline
      render "offline"
    end
  end
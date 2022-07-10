Rails.application.routes.draw do
  scope :people do
    get '/' => 'people#index'
    post '/import' => 'people#import'
  end
end

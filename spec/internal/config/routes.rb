Rails.application.routes.draw do
  mount Kapnismology::Engine, at: '/smoke_test'
end

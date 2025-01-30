Rails.application.routes.draw do
  root 'turnos#index'
  
  resources :turnos do
    collection do
      post 'registrar_entrada'
      post 'registrar_salida'
      get 'detalles/:empleado', to: 'turnos#detalles', as: 'detalles'
    end
  end
end